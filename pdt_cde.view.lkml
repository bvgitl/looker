view: pdt_cde {
  derived_table: {
    sql: SELECT
              cd_magasin,
              CAST(DATETIME_TRUNC(dte_commande, DAY) AS DATE) AS dte_cde,
              count(distinct(cd_commande)) as Nbre_commande ,
              sum(Total_HT) as Total_HT
            FROM `bv-prod.Matillion_Perm_Table.COMMANDES`
            group by 1,2
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.cd_magasin ;;
  }

  dimension: dte_cde {
    type: date
    datatype: date
    sql: ${TABLE}.dte_cde ;;
  }

  dimension: nbre_commande {
    type: number
    sql: ${TABLE}.Nbre_commande ;;
  }

  dimension: total_ht {
    type: number
    sql: ${TABLE}.Total_HT ;;
  }

  set: detail {
    fields: [cd_magasin, dte_cde, nbre_commande, total_ht]
  }
}
