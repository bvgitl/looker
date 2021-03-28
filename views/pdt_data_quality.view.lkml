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
        'Articles' AS Origine
  from `bv-prod.Matillion_Perm_Table.TF_VENTE`

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
        'Magasins' AS Origine
    from `bv-prod.Matillion_Perm_Table.TF_VENTE_MAG`

        LIMIT 10
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
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

  set: detail {
    fields: [
      cd_site_ext,
      dte_vte_date,
      typ_vente,
      ca_ht,
      marge_brute
    ]
  }
}
