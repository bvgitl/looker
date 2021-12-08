view: sql_runner_query_moy_div {
  derived_table: {
    sql: with tmp as (
          SELECT cd_commande, dte_commande, count(distinct division) as count_div
          FROM `bv-prod.looker_pg.ref_cmd_division`
          group by cd_commande, dte_commande
          order by cd_commande
      )
      select avg(count_div) as moy_div_achat
      from tmp
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: moy_div_achat {
    type: number
    sql: ${TABLE}.moy_div_achat ;;
    drill_fields: [detail*]
  }

  dimension_group: dte_commande {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: cast(${TABLE}.dte_commande as timestamp );;
    drill_fields: [detail*]
  }

  set: detail {
    fields: [count,dte_commande_date, moy_div_achat]
  }
}
