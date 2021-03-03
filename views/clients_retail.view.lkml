view: clients_retail {
  sql_table_name: `ods.clients_retail`
    ;;

  dimension: adresse1 {
    type: string
    sql: ${TABLE}.Adresse1 ;;
  }

  dimension: adresse2 {
    type: string
    sql: ${TABLE}.Adresse2 ;;
  }

  dimension: adresse3 {
    type: string
    sql: ${TABLE}.Adresse3 ;;
  }

  dimension: categorie {
    type: string
    sql: ${TABLE}.Categorie ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_MAGASIN ;;
  }

  dimension: cd_stru_ext {
    type: string
    sql: ${TABLE}.CD_STRU_EXT ;;
  }

  dimension: civilite {
    type: string
    sql: ${TABLE}.civilite ;;
  }

  dimension: code {
    type: string
    sql: ${TABLE}.Code ;;
  }

  dimension: compt {
    type: string
    sql: ${TABLE}.Compt ;;
  }

  dimension: courriel {
    type: string
    sql: ${TABLE}.Courriel ;;
  }

  dimension: cp {
    type: string
    sql: ${TABLE}.cp ;;
  }

  dimension: date_crea_src {
    type: string
    sql: ${TABLE}.date_crea_src ;;
  }

  dimension: date_dern_achat {
    type: string
    sql: ${TABLE}.date_dern_achat ;;
  }

  dimension: date_maj_src {
    type: string
    sql: ${TABLE}.date_maj_src ;;
  }

  dimension: fb_description {
    type: string
    sql: ${TABLE}.fb_description ;;
  }

  dimension: fb_ip {
    type: string
    sql: ${TABLE}.fb_ip ;;
  }

  dimension: fb_partage_facebook {
    type: string
    sql: ${TABLE}.fb_partage_facebook ;;
  }

  dimension: fb_partage_twitter {
    type: string
    sql: ${TABLE}.fb_partage_twitter ;;
  }

  dimension: fb_participations {
    type: string
    sql: ${TABLE}.fb_participations ;;
  }

  dimension: fb_secteur {
    type: string
    sql: ${TABLE}.fb_secteur ;;
  }

  dimension: mag_code {
    type: string
    sql: ${TABLE}.mag_code ;;
  }

  dimension: mag_lib {
    type: string
    sql: ${TABLE}.mag_lib ;;
  }

  dimension: mag_pays {
    type: string
    sql: ${TABLE}.mag_Pays ;;
  }

  dimension: mag_sys {
    type: string
    sql: ${TABLE}.mag_sys ;;
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.Nom ;;
  }

  dimension: optin {
    type: number
    sql: ${TABLE}.Optin ;;
  }

  dimension: periode {
    type: number
    sql: ${TABLE}.periode ;;
  }

  dimension: prenom {
    type: string
    sql: ${TABLE}.Prenom ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension_group: tec_date_alim {
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
    sql: ${TABLE}.TEC_date_alim ;;
  }

  dimension: tec_date_maj {
    type: string
    sql: ${TABLE}.TEC_date_maj ;;
  }

  dimension: tec_fic_src {
    type: string
    sql: ${TABLE}.TEC_Fic_src ;;
  }

  dimension: tec_num_ligne {
    type: number
    sql: ${TABLE}.TEC_Num_Ligne ;;
  }

  dimension: tec_raw {
    type: string
    sql: ${TABLE}.TEC_RAW ;;
  }

  dimension: tel_fixe {
    type: number
    sql: ${TABLE}.Tel_fixe ;;
  }

  dimension: tel_port {
    type: string
    sql: ${TABLE}.Tel_port ;;
  }

  dimension: ville {
    type: string
    sql: ${TABLE}.ville ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
