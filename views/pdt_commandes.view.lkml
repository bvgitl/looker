view: pdt_commandes {
  derived_table: {
    sql: SELECT
      cd_magasin,
      CAST(DATETIME_TRUNC(dte_cde, DAY) AS DATE) AS dte_cde,
      sum(Total_HT) as total_ht,
      COUNT(distinct(numero_commande)) as nbre_commande,
      row_number() OVER(order by cd_magasin) AS primary_key
FROM `bv-prod.Matillion_Perm_Table.commandes`
group by 1,2
 ;;
    persist_for: "24 hours"
  }

  dimension: primary_key {
    type: number
    primary_key: yes
    sql: ${TABLE}.primary_key ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.cd_magasin ;;
  }

  dimension_group : dte_cde {
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
    datatype: date
    sql: ${TABLE}.dte_cde ;;
  }

  dimension: total_ht {
    type: number
    sql: ${TABLE}.total_ht ;;
  }

  dimension: nbre_commande {
    type: number
    sql: ${TABLE}.nbre_commande ;;
  }

  set: detail {
    fields: [cd_magasin, total_ht, nbre_commande]
  }
}
