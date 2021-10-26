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

explore : factu_campagne {}
explore : ref_client_mag {}
explore : ref_cmd_produit {}
explore : ref_campagne {}


explore: pdt_vente {}

explore: pdt_famille {}

explore: google_sheet {}

explore: sql_runner_query {}

explore: log_bcp {}
explore: log_bcp_landing {}

explore: tf_vente {
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${tf_vente.cd_site_ext}=${magasins.cd_logiciel} ;;
  }
}


explore: pdt_data_quality {
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${pdt_data_quality.cd_site_ext}=${magasins.cd_logiciel} ;;
  }
}


explore: ventes_devise {
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${ventes_devise.cd_magasin}=${magasins.cd_logiciel} ;;
  }
}

explore: article_dwh {
  join: tf_vente {
    type: left_outer
    relationship: many_to_one
    sql_on: ${article_dwh.c_article} = ${tf_vente.cd_article} ;;
  }
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${magasins.cd_magasin}=${tf_vente.cd_site_ext} ;;
  }
  join: four_dwh {
    type: left_outer
    relationship: many_to_one
    sql_on: ${four_dwh.c_fournisseur}=${article_dwh.c_fournisseur} ;;
  }
  join: marques {
    type: left_outer
    relationship: many_to_one
    sql_on: ${marques.cd_marque}=${article_dwh.c_marque} ;;
  }

}
