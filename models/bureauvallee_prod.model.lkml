connection: "bigquery_prod"

# include all the views
include: "/views/**/*.view"
# include: "dashboards/*.dashboard.lookml"
fiscal_month_offset: 3

datagroup: bv_vente_datagroup {
 # sql_trigger: SELECT count(*) FROM TF_VENTE ;;
  max_cache_age: "24 hour"
}

datagroup: bv_vente_digitale_datagroup {
  # sql_trigger: SELECT count(*) FROM commandes ;;
  max_cache_age: "24 hour"
}

persist_with: bv_vente_datagroup


explore: pdt_vente {}

explore: pdt_test_vente {}


explore: pdt_data_quality {
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${pdt_data_quality.cd_site_ext}=${magasins.cd_logiciel} ;;
  }
}

explore: pdt_test {
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${pdt_test.cd_site_ext}=${magasins.cd_logiciel} ;;
  }
}


explore: tf_vente_mag {
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${tf_vente_mag.cd_site_ext}=${magasins.cd_logiciel} ;;
  }
}

explore: ventes_devise {
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${ventes_devise.cd_magasin}=${magasins.cd_logiciel} ;;
  }
}

explore: log_bcp {}



explore: google_sheet {}

explore: commandes {}

explore: magasins {}
