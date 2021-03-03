view: article {
  sql_table_name: `ods.article`
    ;;

  dimension: att_val_f {
    type: string
    sql: ${TABLE}.ATT_VAL_F ;;
  }

  dimension: attribut_f {
    type: string
    sql: ${TABLE}.ATTRIBUT_F ;;
  }

  dimension: cd_accroche_f {
    type: string
    sql: ${TABLE}.CD_ACCROCHE_F ;;
  }

  dimension: cd_article {
    type: string
    sql: ${TABLE}.CD_ARTICLE ;;
  }

  dimension: cd_att_f {
    type: string
    sql: ${TABLE}.CD_ATT_F ;;
  }

  dimension: cd_desc_tech_f {
    type: string
    sql: ${TABLE}.CD_DESC_TECH_F ;;
  }

  dimension: cd_fourn_gencod {
    type: string
    sql: ${TABLE}.CD_FOURN_GENCOD ;;
  }

  dimension: cd_taxe {
    type: string
    sql: ${TABLE}.CD_TAXE ;;
  }

  dimension: cd_titre_f {
    type: string
    sql: ${TABLE}.CD_TITRE_F ;;
  }

  dimension: class_energie {
    type: string
    sql: ${TABLE}.CLASS_ENERGIE ;;
  }

  dimension: codemaitre {
    type: string
    sql: ${TABLE}.CODEMAITRE ;;
  }

  dimension: coef_cdt {
    type: number
    sql: ${TABLE}.COEF_CDT ;;
  }

  dimension: coef_pvc {
    type: number
    sql: ${TABLE}.COEF_PVC ;;
  }

  dimension: critere1 {
    type: string
    sql: ${TABLE}.CRITERE1 ;;
  }

  dimension: critere10 {
    type: string
    sql: ${TABLE}.CRITERE10 ;;
  }

  dimension: critere2 {
    type: string
    sql: ${TABLE}.CRITERE2 ;;
  }

  dimension: critere3 {
    type: string
    sql: ${TABLE}.CRITERE3 ;;
  }

  dimension: critere4 {
    type: string
    sql: ${TABLE}.CRITERE4 ;;
  }

  dimension: critere5 {
    type: string
    sql: ${TABLE}.CRITERE5 ;;
  }

  dimension: critere7 {
    type: string
    sql: ${TABLE}.CRITERE7 ;;
  }

  dimension: critere8 {
    type: string
    sql: ${TABLE}.CRITERE8 ;;
  }

  dimension: critere9 {
    type: string
    sql: ${TABLE}.CRITERE9 ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.DESCRIPTION ;;
  }

  dimension_group: dt_crea {
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
    sql: ${TABLE}.DT_CREA ;;
  }

  dimension_group: dt_crea_art {
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
    sql: ${TABLE}.DT_CREA_ART ;;
  }

  dimension_group: dt_crea_artfourn {
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
    sql: ${TABLE}.DT_CREA_ARTFOURN ;;
  }

  dimension_group: dt_crea_gencod {
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
    sql: ${TABLE}.DT_CREA_GENCOD ;;
  }

  dimension_group: dt_deb_pa {
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
    sql: ${TABLE}.DT_DEB_PA ;;
  }

  dimension_group: dt_deb_pv {
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
    sql: ${TABLE}.DT_DEB_PV ;;
  }

  dimension_group: dt_mod_art {
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
    sql: ${TABLE}.DT_MOD_ART ;;
  }

  dimension_group: dt_mod_artfourn {
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
    sql: ${TABLE}.DT_MOD_ARTFOURN ;;
  }

  dimension_group: dt_mod_gencod {
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
    sql: ${TABLE}.DT_MOD_GENCOD ;;
  }

  dimension_group: dt_modif {
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
    sql: ${TABLE}.DT_MODIF ;;
  }

  dimension: ecotaxe {
    type: string
    sql: ${TABLE}.ECOTAXE ;;
  }

  dimension: gamme {
    type: string
    sql: ${TABLE}.GAMME ;;
  }

  dimension: gencod {
    type: string
    sql: ${TABLE}.GENCOD ;;
  }

  dimension: id_article {
    type: number
    sql: ${TABLE}.ID_ARTICLE ;;
  }

  dimension: id_division {
    type: number
    sql: ${TABLE}.ID_DIVISION ;;
  }

  dimension: id_famille {
    type: number
    sql: ${TABLE}.ID_FAMILLE ;;
  }

  dimension: id_fourn {
    type: number
    sql: ${TABLE}.ID_FOURN ;;
  }

  dimension: id_marque {
    type: number
    sql: ${TABLE}.ID_MARQUE ;;
  }

  dimension: id_ss_famille {
    type: number
    sql: ${TABLE}.ID_SS_FAMILLE ;;
  }

  dimension: is_maitre {
    type: string
    sql: ${TABLE}.IS_MAITRE ;;
  }

  dimension: libelle {
    type: string
    sql: ${TABLE}.LIBELLE ;;
  }

  dimension: pa_net {
    type: number
    sql: ${TABLE}.PA_NET ;;
  }

  dimension: partnumber {
    type: string
    sql: ${TABLE}.PARTNUMBER ;;
  }

  dimension: photo1 {
    type: string
    sql: ${TABLE}.PHOTO1 ;;
  }

  dimension: photo2 {
    type: string
    sql: ${TABLE}.PHOTO2 ;;
  }

  dimension: photo3 {
    type: string
    sql: ${TABLE}.PHOTO3 ;;
  }

  dimension: photo4 {
    type: string
    sql: ${TABLE}.PHOTO4 ;;
  }

  dimension: photo5 {
    type: string
    sql: ${TABLE}.PHOTO5 ;;
  }

  dimension: prix_ttc_f {
    type: number
    sql: ${TABLE}.PRIX_TTC_F ;;
  }

  dimension: pv_net {
    type: number
    sql: ${TABLE}.PV_NET ;;
  }

  dimension: qt_cde_min {
    type: number
    sql: ${TABLE}.QT_CDE_MIN ;;
  }

  dimension: rf_fourn {
    type: string
    sql: ${TABLE}.RF_FOURN ;;
  }

  dimension: statut_art {
    type: number
    sql: ${TABLE}.STATUT_ART ;;
  }

  dimension: statut_art_fourn {
    type: number
    sql: ${TABLE}.STATUT_ART_FOURN ;;
  }

  dimension: tx_tva_f {
    type: number
    sql: ${TABLE}.TX_TVA_F ;;
  }

  dimension: typ_article {
    type: string
    sql: ${TABLE}.TYP_ARTICLE ;;
  }

  dimension: unite_achat {
    type: string
    sql: ${TABLE}.UNITE_ACHAT ;;
  }

  dimension: unite_cond_ach {
    type: string
    sql: ${TABLE}.UNITE_COND_ACH ;;
  }

  dimension: unite_cond_lib {
    type: string
    sql: ${TABLE}.UNITE_COND_LIB ;;
  }

  dimension: unite_stock {
    type: string
    sql: ${TABLE}.UNITE_STOCK ;;
  }

  dimension: unite_vente {
    type: string
    sql: ${TABLE}.UNITE_VENTE ;;
  }

  dimension: video1 {
    type: string
    sql: ${TABLE}.VIDEO1 ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
