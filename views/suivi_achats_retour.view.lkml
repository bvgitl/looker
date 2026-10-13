view: suivi_achats_retour {
  sql_table_name: `bv-prod.Matillion_Perm_Table.PRODACH_retour` ;;

  dimension: codefour {
    type: number
    sql: ${TABLE}.codefour ;;
  }
  dimension: codemag {
    type: string
    sql: ${TABLE}.codemag ;;
  }
  dimension: ctrlfact {
    type: string
    sql: ${TABLE}.ctrlfact ;;
  }
  dimension_group: datemajrec {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    datatype: datetime
    sql: ${TABLE}.datemajrec ;;
  }
  dimension_group: daterec {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.daterec ;;
  }
  dimension: devisecde {
    type: string
    sql: ${TABLE}.devisecde ;;
  }
  dimension: nomfour {
    type: string
    sql: ${TABLE}.nomfour ;;
  }
  dimension: numbl {
    type: string
    sql: ${TABLE}.numbl ;;
  }
  dimension: numcde {
    type: string
    sql: ${TABLE}.numcde ;;
  }
  dimension: numrec {
    type: string
    sql: ${TABLE}.numrec ;;
  }
  dimension: reclig_avtremise {
    type: number
    sql: ${TABLE}.reclig_avtremise ;;
  }
  dimension: reclig_deee_unit_ttc {
    type: number
    sql: ${TABLE}.reclig_DEEE_unit_TTC ;;
  }
  dimension: reclig_mt_tva {
    type: number
    sql: ${TABLE}.reclig_mtTVA ;;
  }
  dimension: reclig_mtt_ht_aprremise {
    type: number
    sql: ${TABLE}.reclig_mttHT_aprremise ;;
  }
  dimension: reclig_mtt_ttc_aprremise {
    type: number
    sql: ${TABLE}.reclig_mttTTC_aprremise ;;
  }
  dimension: reclig_pu_avtremise {
    type: number
    sql: ${TABLE}.reclig_pu_avtremise ;;
  }
  dimension: reclig_qte {
    type: number
    sql: ${TABLE}.reclig_qte ;;
  }
  dimension: reclig_remises {
    type: number
    sql: ${TABLE}.reclig_remises ;;
  }
  dimension: reclig_ttc {
    type: number
    sql: ${TABLE}.reclig_ttc ;;
  }
  dimension: reclig_tva {
    type: number
    sql: ${TABLE}.reclig_tva ;;
  }
  measure: count {
    type: count
  }
}
