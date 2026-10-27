view: suivi_achats_cmd {
  sql_table_name: `bv-prod.Matillion_Perm_Table.PRODACH_cmd` ;;

  dimension: cde_qte {
    type: number
    sql: ${TABLE}.cde_qte ;;
  }
  dimension: cde_total_ht_aprremises {
    type: number
    sql: ${TABLE}.cde_totalHT_aprremises ;;
  }
  dimension: cde_total_ht_avtremises {
    type: number
    sql: ${TABLE}.cde_totalHT_avtremises ;;
  }
  dimension: cde_total_ht_remises {
    type: number
    sql: ${TABLE}.cde_totalHT_remises ;;
  }
  dimension: cdecloturee {
    type: string
    sql: ${TABLE}.cdecloturee ;;
  }
  dimension: cdeedi {
    type: string
    sql: ${TABLE}.cdeedi ;;
  }
  dimension: cdeorigine {
    type: string
    sql: ${TABLE}.cdeorigine ;;
  }
  dimension: cdereliquat {
    type: string
    sql: ${TABLE}.cdereliquat ;;
  }
  dimension: codefour {
    type: number
    sql: ${TABLE}.codefour ;;
  }
  dimension: codemag {
    type: string
    sql: ${TABLE}.codemag ;;
  }
  dimension_group: datecde {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.datecde ;;
  }
  dimension: devisecde {
    type: string
    sql: ${TABLE}.devisecde ;;
  }
  dimension: nomfour {
    type: string
    sql: ${TABLE}.nomfour ;;
  }
  dimension: numcde {
    type: string
    sql: ${TABLE}.numcde ;;
  }
  measure: count {
    type: count
  }
  measure: sum_montantHT {
    type :  sum
    sql: ROUND(${cde_total_ht_aprremises},2) ;;
  }
  measure: sum_qte {
    type :  sum
    sql: ${cde_qte} ;;
  }
}
