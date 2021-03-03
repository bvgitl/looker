view: dig_nos_magasins {
  sql_table_name: `ods.dig_nos_magasins`
    ;;

  dimension: adresse {
    type: string
    sql: ${TABLE}.Adresse ;;
  }

  dimension: adresse_url_page_magasin {
    type: string
    sql: ${TABLE}.Adresse_Url_page_magasin ;;
  }

  dimension: animateur {
    type: string
    sql: ${TABLE}.Animateur ;;
  }

  dimension: code_magasin {
    type: string
    sql: ${TABLE}.code_magasin ;;
  }

  dimension: code_postal {
    type: string
    sql: ${TABLE}.Code_postal ;;
  }

  dimension: compl__ment_adresse {
    type: string
    sql: ${TABLE}.Compl__ment_Adresse ;;
  }

  dimension: d__lais_de_livraison {
    type: number
    sql: ${TABLE}.D__lais_de_livraison ;;
  }

  dimension_group: date_ouverture {
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
    sql: ${TABLE}.Date_ouverture ;;
  }

  dimension: format_du_magasin {
    type: string
    sql: ${TABLE}.Format_du_magasin ;;
  }

  dimension: frais_de_livraison {
    type: number
    sql: ${TABLE}.Frais_de_livraison ;;
  }

  dimension: horaires_dimanche {
    type: string
    sql: ${TABLE}.Horaires_Dimanche ;;
  }

  dimension: horaires_jeudi {
    type: string
    sql: ${TABLE}.Horaires_jeudi ;;
  }

  dimension: horaires_lundi {
    type: string
    sql: ${TABLE}.Horaires_lundi ;;
  }

  dimension: horaires_mardi {
    type: string
    sql: ${TABLE}.Horaires_mardi ;;
  }

  dimension: horaires_mercredi {
    type: string
    sql: ${TABLE}.Horaires_mercredi ;;
  }

  dimension: horaires_samedi {
    type: string
    sql: ${TABLE}.Horaires_Samedi ;;
  }

  dimension: horaires_vendredi {
    type: string
    sql: ${TABLE}.Horaires_vendredi ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.Latitude ;;
  }

  dimension: livraison_activ__e__ {
    type: number
    sql: ${TABLE}.Livraison_activ__e__ ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.Longitude ;;
  }

  dimension: minimum_de_commande_livraison {
    type: number
    sql: ${TABLE}.Minimum_de_commande_livraison ;;
  }

  dimension: nom_du_magasin {
    type: string
    sql: ${TABLE}.Nom_du_magasin ;;
  }

  dimension: numero_rcs {
    type: string
    sql: ${TABLE}.Numero_RCS ;;
  }

  dimension: numero_tva_intracommunautaire {
    type: string
    sql: ${TABLE}.Numero_TVA_intracommunautaire ;;
  }

  dimension: pays {
    type: string
    sql: ${TABLE}.Pays ;;
  }

  dimension: r__gion {
    type: string
    sql: ${TABLE}.R__gion ;;
  }

  dimension: taille_surface_commerciale {
    type: number
    sql: ${TABLE}.Taille_surface_commerciale ;;
  }

  dimension: tel_fixe {
    type: string
    sql: ${TABLE}.Tel_fixe ;;
  }

  dimension: type_magasin {
    type: string
    sql: ${TABLE}.Type_magasin ;;
  }

  dimension: ville {
    type: string
    sql: ${TABLE}.Ville ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
