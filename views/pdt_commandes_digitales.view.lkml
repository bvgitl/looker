view: pdt_commandes_digitales {

  derived_table: {
    sql: select
        c.cd_magasin AS cd_magasin ,
        CAST(DATETIME_TRUNC(c.dte_cde, DAY) AS DATE) AS dte_cde ,
        pc.Quantite_commandee AS Quantite_commandee ,
        c.Total_HT AS Total_HT ,
        row_number() OVER(ORDER BY c.cd_magasin, c.dte_cde) AS primary_key
        from `bv-prod.Matillion_Perm_Table.produit_commande` AS pc

  LEFT JOIN  `bv-prod.Matillion_Perm_Table.commandes` AS c

  ON pc.cd_commande = c.numero_commande
 ;;

#  datagroup_trigger: bv_vente_digitale_datagroup
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

  dimension: dte_cde {
    type: date
    datatype: date
    sql: ${TABLE}.dte_cde ;;
  }

  dimension: quantite_commandee {
    type: number
    sql: ${TABLE}.Quantite_commandee ;;
  }

  dimension: total_ht {
    type: number
    sql: ${TABLE}.Total_HT ;;
  }

  set: detail {
    fields: [cd_magasin, dte_cde, quantite_commandee, total_ht, primary_key]
  }
}
