view: pdt_commandes_digitales {

  derived_table: {
    sql: select
        c.cd_magasin AS cd_magasin ,
        CAST(DATETIME_TRUNC(c.dte_commande, DAY) AS DATE) AS dte_commande ,
        pc.Quantite_commandee AS Quantite_commandee ,
        c.Total_HT AS Total_HT ,
        row_number() OVER(ORDER BY c.cd_magasin, c.dte_commande) AS primary_key

  from `bv-prod.Matillion_Perm_Table.produit_commande` AS pc

  LEFT JOIN  `bv-prod.Matillion_Perm_Table.commandes` AS c

  ON pc.cd_commande = c.cd_commande

 ;;
    #  datagroup_trigger: bv_vente_digitale_datagroup
    }

    dimension: primary_key {
      type: number
      primary_key: yes
      hidden: yes
      sql: ${TABLE}.primary_key ;;
    }

    dimension: cd_magasin {
      type: string
      sql: ${TABLE}.cd_magasin ;;
    }

    dimension_group: dte_commande {
      type: time
      timeframes: [date, week, month, quarter, year, raw, month_name, fiscal_month_num, fiscal_quarter, fiscal_quarter_of_year, fiscal_year]
      datatype: datetime
      sql: ${TABLE}.dte_commande ;;
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
      fields: [cd_magasin, quantite_commandee, total_ht, primary_key]
    }

}
