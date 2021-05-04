view: article_dwh {
  sql_table_name: `bv-prod.Matillion_Perm_Table.ARTICLE_DWH`
    ;;

  dimension: b_export_web {
    type: string
    sql: ${TABLE}.b_Export_Web ;;
  }

  dimension: b_maitre {
    type: string
    sql: ${TABLE}.b_Maitre ;;
  }

  dimension: c_arbo_web {
    type: string
    sql: ${TABLE}.c_Arbo_Web ;;
  }

  dimension: c_arbo_web_2 {
    type: string
    sql: ${TABLE}.c_Arbo_Web_2 ;;
  }

  dimension: c_arbo_web_3 {
    type: string
    sql: ${TABLE}.c_Arbo_Web_3 ;;
  }

  dimension: c_article {
    type: string
    sql: ${TABLE}.c_Article ;;
  }

  dimension: c_blanc {
    type: string
    sql: ${TABLE}.c_Blanc ;;
  }

  dimension: c_conditionnement {
    type: string
    sql: ${TABLE}.c_Conditionnement ;;
  }

  dimension: c_conditionnement_achat {
    type: string
    sql: ${TABLE}.c_Conditionnement_achat ;;
  }

  dimension: c_critere_7 {
    type: string
    sql: ${TABLE}.c_Critere_7 ;;
  }

  dimension: c_critere_9 {
    type: string
    sql: ${TABLE}.c_Critere_9 ;;
  }

  dimension: c_evenement {
    type: string
    sql: ${TABLE}.c_Evenement ;;
  }

  dimension: c_evenement_2 {
    type: string
    sql: ${TABLE}.c_Evenement_2 ;;
  }

  dimension: c_fixe {
    type: string
    sql: ${TABLE}.c_Fixe ;;
  }

  dimension: c_fournisseur {
    type: string
    sql: ${TABLE}.c_Fournisseur ;;
  }

  dimension: c_fournisseur_2 {
    type: string
    sql: ${TABLE}.c_Fournisseur_2 ;;
  }

  dimension: c_gamme {
    type: string
    sql: ${TABLE}.c_Gamme ;;
  }

  dimension: c_gencode {
    type: string
    sql: ${TABLE}.c_Gencode ;;
  }

  dimension: c_marque {
    type: string
    sql: ${TABLE}.c_Marque ;;
  }

  dimension: c_niv_2 {
    type: string
    sql: ${TABLE}.c_Niv_2 ;;
  }

  dimension: c_note {
    type: string
    sql: ${TABLE}.c_Note ;;
  }

  dimension: c_origine {
    type: string
    sql: ${TABLE}.c_Origine ;;
  }

  dimension: c_reference_fournisseur {
    type: string
    sql: ${TABLE}.c_Reference_fournisseur ;;
  }

  dimension: c_sensibilite {
    type: string
    sql: ${TABLE}.c_Sensibilite ;;
  }

  dimension: c_sensibilite_2 {
    type: string
    sql: ${TABLE}.c_Sensibilite_2 ;;
  }

  dimension: c_taxe {
    type: string
    sql: ${TABLE}.c_Taxe ;;
  }

  dimension: c_type {
    type: string
    sql: ${TABLE}.c_Type ;;
  }

  dimension: c_unite_achat {
    type: string
    sql: ${TABLE}.c_Unite_achat ;;
  }

  dimension: c_unite_gestion {
    type: string
    sql: ${TABLE}.c_Unite_Gestion ;;
  }

  dimension: c_validite_1 {
    type: string
    sql: ${TABLE}.c_Validite_1 ;;
  }

  dimension: c_validite_2 {
    type: string
    sql: ${TABLE}.c_Validite_2 ;;
  }

  dimension: d_creation {
    type: string
    sql: ${TABLE}.d_Creation ;;
  }

  dimension: d_creation_2 {
    type: string
    sql: ${TABLE}.d_Creation_2 ;;
  }

  dimension: d_creation_3 {
    type: string
    sql: ${TABLE}.d_Creation_3 ;;
  }

  dimension: d_modification {
    type: string
    sql: ${TABLE}.d_Modification ;;
  }

  dimension: d_modification_2 {
    type: string
    sql: ${TABLE}.d_Modification_2 ;;
  }

  dimension: d_modification_3 {
    type: string
    sql: ${TABLE}.d_Modification_3 ;;
  }

  dimension: d_pan {
    type: string
    sql: ${TABLE}.d_Pan ;;
  }

  dimension: dte_create {
    type: string
    sql: ${TABLE}.Dte_create ;;
  }

  dimension: l_article_long {
    type: string
    sql: ${TABLE}.l_Article_long ;;
  }

  dimension: l_conditionnement {
    type: string
    sql: ${TABLE}.l_Conditionnement ;;
  }

  dimension: l_description {
    type: string
    sql: ${TABLE}.l_Description ;;
  }

  dimension: n_coef_pvc {
    type: string
    sql: ${TABLE}.n_Coef_PVC ;;
  }

  dimension: n_prix_achat_net {
    type: number
    sql: ${TABLE}.n_Prix_Achat_net ;;
  }

  dimension: n_pvc_ht {
    type: number
    sql: ${TABLE}.n_PVC_ht ;;
  }

  dimension: n_stock_impact {
    type: string
    sql: ${TABLE}.n_Stock_impact ;;
  }

  dimension: n_tva {
    type: number
    sql: ${TABLE}.n_TVA ;;
  }

  dimension: recmod_1 {
    type: string
    sql: ${TABLE}.Recmod_1 ;;
  }

  dimension: recmod_2 {
    type: string
    sql: ${TABLE}.Recmod_2 ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
