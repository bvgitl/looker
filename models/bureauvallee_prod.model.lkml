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

explore: Factu_campagne {}
explore: ref_client_mag {}

explore: ref_cmd_produit {
  join: ref_cmd_division {
    relationship: one_to_many
    sql_on: ${ref_cmd_division.cd_commande} = ${ref_cmd_produit.cd_commande} ;;
  }
}
explore: ref_campagne {}

explore: ref_client_cmd {}

explore: suivi_ga {}
explore: ref_optin {}
explore: ref_cmd_division {}
explore: sql_runner_query_division {}
explore: sql_runner_query_moy_div {}
explore: derived_customer_cmd {}

map_layer: my_map {
  url: "https://raw.githubusercontent.com/deldersveld/topojson/master/countries/france/fr-departments.json"
  #url: "https://raw.githubusercontent.com/brechtv/looker_map_layers/master/fr-departments.json"
  property_key: "neighborhood"
 # max_zoom_level: 12
#  min_zoom_level: 2
}


explore: pdt_vente {}

explore: pdt_famille {}

explore: data_quality_ventes_google_sheet {}

explore: sql_runner_query {}

#explore: log_bcp {}
#explore: log_bcp_landing {}

explore: tf_vente {
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${tf_vente.cd_magasin}=${magasins.cd_magasin} ;;
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

explore: tract {
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${tract.CodeActeur}=${magasins.cd_magasin} ;;
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
    sql_on: ${magasins.cd_magasin}=${tf_vente.cd_magasin} ;;
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
  join: stock_utd {
    type: left_outer
    relationship: many_to_one
    sql_on: ${stock_utd.CodeActeur}=${magasins.cd_magasin} AND  ${stock_utd.CodeArticle}=${article_dwh.c_article};;
  }

}

explore:  monitoring {}
