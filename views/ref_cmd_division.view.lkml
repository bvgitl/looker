view: ref_cmd_division {
  sql_table_name: `bv-prod.looker_pg.ref_cmd_division`
    ;;

  dimension: ca_produit {
    type: number
    sql: ${TABLE}.ca_produit ;;
    drill_fields: [sheet_client*]
  }

  dimension: cd_commande {
    type: string
    sql: ${TABLE}.cd_commande ;;
    drill_fields: [sheet_client*]
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.cd_magasin ;;
    drill_fields: [sheet_client*]
  }

  dimension: cd_produit {
    type: string
    sql: ${TABLE}.cd_produit ;;
    drill_fields: [sheet_client*]
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
    drill_fields: [sheet_client*]
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
    sql: cast(${TABLE}.dte_commande as timestamp );;
    drill_fields: [sheet_client*]
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

  measure: count_division {
    type: count_distinct
    sql: ${TABLE}.division ;;
    drill_fields: [division]
  }

  measure: count_Famille {
    type: count_distinct
    sql: ${TABLE}.Famille ;;
    drill_fields: [division, famille]
  }

  measure: count_sous_famille {
    type: count_distinct
    sql: ${TABLE}.SousFamille ;;
    drill_fields: [division, famille,sous_famille]
  }

  measure: count_marque {
    type: count_distinct
    sql: ${TABLE}.Niveau4 ;;
    drill_fields: [division, famille,sous_famille,niveau4]
  }

  measure: somme_ca {
    type: sum
    sql: ${TABLE}.ca_produit ;;
    drill_fields: [sheet_client*]
  }

  measure: count {
    type: count
    drill_fields: [sheet_client*]
  }


  set: sheet_client {
    fields: [customer_id,cd_commande,cd_magasin,cd_produit,dte_commande_date,ca_produit,division,famille,sous_famille,niveau4]
  }
}
