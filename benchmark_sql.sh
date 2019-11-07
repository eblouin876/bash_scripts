function benchSql() {
  source .env
  if [[ $@ ]]; then
        local arr=("$@")
        for ((i=0; i< ${#arr[@]}; i++ )); do
            local var=${arr[i]}
            case $var in
                "-d" | "--database")
                    local DATABASE=$(_parseFlagContent $i $@)
                    [[ -n "$DATABASE" ]] || local DATABASE=$(_prompt "Enter the database you wish to update: ")
                ;;
                "-n")
                    local TRIALS=$(_parseFlagContent $i $@)
                ;;
                *)
                    continue
                ;;
            esac
        done
    fi
  _bench_ "$DATABASE" "$TRIALS"
}

function _bench_(){
  source .env
  local DATABASE="$1"
  local TRIALS="$2"
  [[ -n "$TRIALS" ]] || local TRIALS="10"
  [[ -n "$DATABASE" ]] || local DATABASE="$database"
  local COMMAND1=$(_prompt "Query 1: ")
  local COMMAND2=$(_prompt "Query 2: ")
  _setSqlProcedure_ "$DATABASE" "$TRIALS"
  warn "Executing query 1"
  local TIME1=$(_benchmark_ "$COMMAND1" "$DATABASE" "$TRIALS"| cut -d\  -f2)
  warn "Executing query 2"
  local TIME2=$(_benchmark_ "$COMMAND2" "$DATABASE" "$TRIALS"| cut -d\  -f2)
  local IMPACT=$(bc <<< "scale=3; ($TIME2/$TIME1)*100")
  echo "Time1: ${TIME1}ms, Time2: ${TIME2}ms, Impact: Query 2 takes ${IMPACT}% the time of Query 1 averaged over "
}

function _setSqlProcedure_() {
  source .env
  local FILE="benchmarkproc.sql"
  local CUR=$(pwd)
  local DATABASE="$1"
  local TRIALS="$2"
  cd ~/.shell_scripts
  touch $FILE
  echo "    USE ${DATABASE};
    DROP PROCEDURE IF EXISTS benchmark_query;
    DELIMITER @@;
    CREATE PROCEDURE benchmark_query (IN querystring TEXT)
    BEGIN
      DECLARE v1 INT;
      SET @sqlstring = querystring;
      PREPARE myquery FROM @sqlstring;
      SET v1 = 0;
      WHILE v1 < ${TRIALS} DO
        EXECUTE myquery;
        DROP TEMPORARY TABLE benchmark;
        SET v1 = v1 + 1;
      END WHILE;
    END;
    @@;
    DELIMITER ;" >> ${FILE}
  mysql "$DATABASE" -u"$dbusr" -p"$dbpass" < benchmarkproc.sql 2>/dev/null
  rm benchmarkproc.sql
  cd $CUR
}

function _benchmark_() {
  source .env
  local COMMAND="$1"
  local DATABASE="$2"
  local TRIALS="$3"
  local DIVISOR=$((1000*${TRIALS}))
  local BENCHTIME=$(echo "SET @start = (SELECT current_timestamp(6));CALL benchmark_query(\"CREATE TEMPORARY TABLE benchmark $COMMAND\");SET @end = (SELECT current_timestamp(6));SET @query_average = (SELECT ROUND(TIMESTAMPDIFF(MICROSECOND, @start, @end) / ${DIVISOR} , 2));SELECT @query_average;" | mysql "$DATABASE" -u"$dbusr" -p"$dbpass" 2>/dev/null)
  echo $BENCHTIME
}