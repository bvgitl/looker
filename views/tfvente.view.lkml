view: tfvente {
  sql_table_name: `bv-prod.Matillion_Perm_Table.TFVENTE`
    ;;

  dimension: an_sem {
    type: string
    sql: ${TABLE}.An_Sem ;;
  }

  dimension: annee {
    type: string
    sql: ${TABLE}.Annee ;;
  }

  dimension: ca_ht {
    type: number
    sql: ${TABLE}.ca_ht ;;
  }

  dimension: ca_net {
    type: number
    sql: ${TABLE}.ca_net ;;
  }

  dimension: cd_article {
    type: string
    sql: ${TABLE}.CD_Article ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
  }

  dimension: cd_niv_1 {
    type: string
    sql: ${TABLE}.CD_Niv_1 ;;
  }

  dimension: cd_niv_2 {
    type: string
    sql: ${TABLE}.CD_Niv_2 ;;
  }

  dimension: cd_niv_3 {
    type: string
    sql: ${TABLE}.CD_Niv_3 ;;
  }

  dimension: cd_pays {
    type: string
    sql: ${TABLE}.CD_Pays ;;
  }

  dimension: cd_site_ext {
    type: string
    sql: ${TABLE}.CD_Site_Ext ;;
  }

  dimension_group: dte_creat {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Dte_creat ;;
  }

  dimension_group: dte_vte {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Dte_Vte ;;
  }

  dimension: jour {
    type: string
    sql: ${TABLE}.Jour ;;
  }

  dimension: marge_brute {
    type: number
    sql: ${TABLE}.marge_brute ;;
  }

  dimension: mois {
    type: string
    sql: ${TABLE}.Mois ;;
  }

  dimension: nb_ticket {
    type: number
    sql: ${TABLE}.nb_ticket ;;
  }

  dimension: num_jour {
    type: string
    sql: ${TABLE}.Num_Jour ;;
  }

  dimension: num_niv_1 {
    type: string
    sql: ${TABLE}.Num_Niv_1 ;;
  }

  dimension: num_niv_2 {
    type: string
    sql: ${TABLE}.Num_Niv_2 ;;
  }

  dimension: num_niv_3 {
    type: string
    sql: ${TABLE}.Num_Niv_3 ;;
  }

  dimension: qtite {
    type: number
    sql: ${TABLE}.Qtite ;;
  }

  dimension: qtite_uvc {
    type: number
    sql: ${TABLE}.Qtite_uvc ;;
  }

  dimension: statut_article {
    type: string
    sql: ${TABLE}.Statut_Article ;;
  }

  dimension: typ_article {
    type: string
    sql: ${TABLE}.Typ_Article ;;
  }

  dimension: typ_vente {
    type: number
    sql: ${TABLE}.Typ_Vente ;;
  }

  dimension: val_achat_gbl {
    type: number
    sql: ${TABLE}.Val_Achat_Gbl ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
