view: ref_magasin {
  sql_table_name: `bv-prod.looker_pg.ref_magasin`
    ;;

  dimension: animateur {
    type: string
    sql: ${TABLE}.Animateur ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
  }

  dimension: format {
    type: string
    sql: ${TABLE}.Format ;;
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.NOM ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
  }

  dimension: tranche_age {
    type: string
    sql: ${TABLE}.Tranche_age ;;
  }

  dimension: typ_mag {
    type: string
    sql: ${TABLE}.TYP_MAG ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
