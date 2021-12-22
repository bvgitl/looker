view: tract {
  sql_table_name: Matillion_Perm_Table.TRACTS_GOOGLE_SHEET ;;

  dimension_group: DateDebutTract {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.DATE_DEBUT_TRACT ;;
  }

  dimension_group: DateFinTract {
    type: time
    timeframes: [
      raw,
      week,
      date,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.DATE_FIN_TRACT ;;
  }

  dimension: CodeActeur {
    type: string
    sql: ${TABLE}.CODE_ACTEUR ;;
  }

  dimension: NomMagasin {
    type: string
    sql: ${TABLE}.NOM_MAGASIN ;;
  }

  dimension: MiseEnAvantWeb {
    type: string
    sql: ${TABLE}.MiseEnAvantWeb ;;
  }

  dimension: BoosterBonial {
    type: string
    sql: ${TABLE}.BoosterBonial ;;
  }

  dimension: Email {
    type: string
    sql: ${TABLE}.Email ;;
  }

  dimension: PostsFacebookGeolocalises {
    type: string
    sql: ${TABLE}.PostsFacebookGeolocalises ;;
  }

  dimension: SMS {
    type: string
    sql: ${TABLE}.SMS ;;
  }

  dimension: SpotRadioShop {
    type: string
    sql: ${TABLE}.SpotRadioShop ;;
  }

  dimension: PLVMoyenKit {
    type: string
    sql: ${TABLE}.PLVMoyenKit ;;
  }

  dimension: PLVGrandKit {
    type: string
    sql: ${TABLE}.PLVGrandKit ;;
  }

  dimension: NomOperation {
    type: string
    sql: ${TABLE}.NOM_OPERATION ;;
  }

  dimension: Specificite {
    type: string
    sql: ${TABLE}.SPECIFICITE  ;;
  }

  dimension: QuantiteTract
  {
    type: number
    sql: ${TABLE}.QTE_TRACT  ;;
  }

  measure: count {
    type: count
    filters: []
    drill_fields: []
  }

}
