view: magasin {
  sql_table_name: `ods.magasin`
    ;;

  dimension: cd_kit {
    type: string
    sql: ${TABLE}.CD_KIT ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_MAGASIN ;;
  }

  dimension: cd_pays {
    type: string
    sql: ${TABLE}.CD_PAYS ;;
  }

  dimension: cd_stru_ext {
    type: string
    sql: ${TABLE}.CD_STRU_EXT ;;
  }

  dimension: cd_stru_pere {
    type: string
    sql: ${TABLE}.CD_STRU_PERE ;;
  }

  dimension: cp {
    type: string
    sql: ${TABLE}.CP ;;
  }

  dimension_group: date_ferm {
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
    sql: ${TABLE}.DATE_FERM ;;
  }

  dimension_group: date_ouv {
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
    sql: ${TABLE}.DATE_OUV ;;
  }

  dimension: id_magasin {
    type: number
    sql: ${TABLE}.ID_MAGASIN ;;
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.NOM ;;
  }

  dimension: nom_court {
    type: string
    sql: ${TABLE}.NOM_COURT ;;
  }

  dimension: progiciel {
    type: string
    sql: ${TABLE}.PROGICIEL ;;
  }

  dimension: raison_soc {
    type: string
    sql: ${TABLE}.RAISON_SOC ;;
  }

  dimension: surf_vte {
    type: number
    sql: ${TABLE}.SURF_VTE ;;
  }

  dimension: typ_mag {
    type: string
    sql: ${TABLE}.TYP_MAG ;;
  }

  dimension: ville {
    type: string
    sql: ${TABLE}.VILLE ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
