view: ref_cmd_division {
  sql_table_name: `bv-prod.looker_pg.ref_cmd_division`
    ;;

  dimension: ca {
    type: number
    sql: ${TABLE}.ca ;;
  }

  dimension: cd_commande {
    type: string
    sql: ${TABLE}.cd_commande ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.cd_magasin ;;
  }

  dimension: cd_produit {
    type: string
    sql: ${TABLE}.cd_produit ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: division {
    type: string
    sql: ${TABLE}.division ;;
  }

  dimension_group: dte_commande {
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
    sql: ${TABLE}.dte_commande ;;
  }

  dimension: famille {
    type: string
    sql: ${TABLE}.Famille ;;
  }

  dimension: libelle {
    type: string
    sql: ${TABLE}.libelle ;;
  }

  dimension: niveau4 {
    type: string
    sql: ${TABLE}.Niveau4 ;;
  }

  dimension: sous_famille {
    type: string
    sql: ${TABLE}.SousFamille ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
