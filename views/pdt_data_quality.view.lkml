view: pdt_data_quality {
  derived_table: {
    sql: select
        CD_Site_Ext ,
        Dte_Vte ,
        Typ_Vente ,
        Val_Achat_Gbl ,
        Qtite ,
        ca_ht ,
        marge_brute ,
        nb_ticket,
        row_number() OVER(ORDER BY CD_Site_Ext , Dte_Vte, Typ_Vente) AS primary_key ,
        'Articles' AS Origine
  from `bv-prod.Matillion_Perm_Table.TFVENTE`

  UNION ALL

  select
        CD_Site_Ext ,
        Dte_Vte ,
        Typ_Vente ,
        Val_Achat_Gbl ,
        Qtite ,
        ca_ht ,
        marge_brute ,
        nb_ticket ,
        row_number() OVER(ORDER BY CD_Site_Ext , Dte_Vte, Typ_Vente) AS primary_key ,
        'Magasins' AS Origine
    from `bv-prod.Matillion_Perm_Table.TFVENTEMAG`
 ;;

  #  datagroup_trigger: bv_vente_datagroup
  }

  dimension: primary_key {
    type: number
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.primary_key ;;
  }

  dimension: cd_site_ext {
    type: string
    sql: ${TABLE}.CD_Site_Ext ;;
  }

  dimension_group: dte_vte {
    type: time
    timeframes: [date, raw]
    datatype: date
    sql: ${TABLE}.Dte_Vte ;;
  }

  dimension: typ_vente {
    type: number
    sql: ${TABLE}.Typ_Vente ;;
  }

  dimension: val_achat_gbl {
    type: number
    sql: ${TABLE}.Val_Achat_Gbl ;;
  }

  dimension: qtite {
    type: number
    sql: ${TABLE}.Qtite ;;
  }

  dimension: ca_ht {
    type: number
    sql: ${TABLE}.ca_ht ;;
  }

  dimension: marge_brute {
    type: number
    sql: ${TABLE}.marge_brute ;;
  }

  dimension: nb_ticket {
    type: number
    sql: ${TABLE}.nb_ticket ;;
  }

  dimension: origine {
    type: string
    sql: ${TABLE}.Origine ;;
  }

  dimension: tx_marge_brute {
    type: number
    sql: ${marge_brute}/NULLIF(${ca_ht},0) ;;
  }


  measure: sum_ca_ht_article {
    label: "ca_ht articles"
    type: sum
    value_format_name: eur
    sql: ${ca_ht} ;;
    filters: [origine: "Articles"]
  }

  measure: sum_marge_brute_article {
    label: "marge_brute articles"
    type: sum
    value_format_name: eur
    sql: ${marge_brute} ;;
    filters: [origine: "Articles"]
  }

  measure: sum_ca_ht_mag {
    label: "ca_ht mag"
    type: sum
    value_format_name: eur
    sql: ${ca_ht} ;;
    filters: [origine: "Magasins"]
  }


  measure: sum_marge_brute_mag {
    label: "marge_brute mag"
    type: sum
    value_format_name: eur
    sql: ${marge_brute} ;;
    filters: [origine: "Magasins"]
  }

  measure: Ecarts_CA {
    type: number
    value_format_name: eur
    sql: ${sum_ca_ht_mag}-${sum_ca_ht_article} ;;
    drill_fields: [sheet_diff*]
  }

  measure: Nb_Lignes_CA_Null {
    label: "Nbre de lignes CA = 0"
    type: count_distinct
    sql: ${primary_key} ;;
    value_format_name: decimal_0
    filters: [origine: "Articles", ca_ht: "0"]
    drill_fields: [sheet_ca*]
  }

  measure: Nb_Lignes_tx_Marge {
    label: "Nbre de lignes tx Marge >1"
    type: count_distinct
    value_format_name: decimal_0
    sql: ${primary_key} ;;
    filters: [origine: "Articles", tx_marge_brute: ">1"]
    drill_fields: [sheet_marge*]
  }

  measure: Nb_Lignes_Marge_Negatif {
    label: "Nbre de lignes Marge <0"
    type: count_distinct
    value_format_name: decimal_0
    sql: ${primary_key} ;;
    filters: [origine: "Articles" , marge_brute: "<0"]
    drill_fields: [sheet_marge*]
  }

  measure: Nb_Mag {
    label: "Nbre de magasins ayant réalisé des ventes"
    type: count_distinct
    value_format_name: decimal_0
    sql: ${cd_site_ext} ;;
    drill_fields: [cd_site_ext]
  }


  measure: Nb_Lignes_Ecarts_ca {
    label: "Nbre de lignes avec écarts CA"
    type: number
    value_format_name: decimal_0
    sql: ${Ecarts_CA} = "-NULL" ;;
    drill_fields: [sheet_diff*]
  }


  measure: Ecarts_magasins {
    type: number
    value_format_name: decimal_0
    sql: ${magasins.Nb_magasins}-${Nb_Mag} ;;
    drill_fields: [magasins.cd_magasin, cd_site_ext]
  }

  set: sheet_ca {
    fields: [magasins.cd_magasin, cd_site_ext, dte_vte_date, typ_vente, ca_ht]
  }


  set: sheet_marge {
    fields: [magasins.cd_magasin, cd_site_ext, dte_vte_date, typ_vente, marge_brute]
  }


  set: sheet_diff {
    fields: [magasins.cd_magasin, cd_site_ext, dte_vte_date, typ_vente, Ecarts_CA]
  }

  set: sheet {
    fields: [magasins.cd_magasin, cd_site_ext, dte_vte_date, typ_vente, ca_ht, marge_brute]
  }
}
