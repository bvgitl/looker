view: sql_runner_query_division {
  derived_table: {
    sql: select *
      EXCEPT (RANG)
      from (
        SELECT
            ref_cmd_division.division  AS ref_cmd_division_division,
            ref_cmd_division.Famille  AS ref_cmd_division_famille,
            ROW_NUMBER() OVER (deduplication) AS RANG,

        FROM `bv-prod.looker_pg.ref_cmd_division`  AS ref_cmd_division
        group by division, Famille
            WINDOW deduplication AS (
                PARTITION BY division
                order by division, count(*) desc
                )
      )

      where RANG = 1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: ref_cmd_division_division {
    type: string
    sql: ${TABLE}.ref_cmd_division_division ;;
  }

  dimension: ref_cmd_division_famille {
    type: string
    sql: ${TABLE}.ref_cmd_division_famille ;;
  }

  set: detail {
    fields: [ref_cmd_division_division, ref_cmd_division_famille]
  }
}
