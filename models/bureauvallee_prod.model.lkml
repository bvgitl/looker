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

explore: suivi_ga_2 {}
explore: Factu_campagne {}
explore: ref_client_mag {}
explore : ref_campagne_triggers {
  sql_always_where: ${camp_name}  like '%Trigger%';;
  join: derived_ga4 {
    relationship: many_to_one
    sql_on: lower(TRIM(RTRIM(split(${ref_campagne_triggers.camp_name}, 'CELL')[offset(0)], '_'))) = lower(${derived_ga4.name}) ;;
  }
}

explore: ref_cmd_produit {
  join: ref_cmd_division {
    relationship: one_to_many
    sql_on: ${ref_cmd_division.cd_commande} = ${ref_cmd_produit.cd_commande} ;;
  }
}
explore: ref_campagne {
  sql_always_where: ${camp_name} not like '%Trigger%' ;;
  join: derived_ga4 {
    relationship: many_to_one
    sql_on: lower(TRIM(RTRIM(split(${ref_campagne.camp_name}, 'CELL')[offset(0)], '_'))) = lower(${derived_ga4.name}) ;;
  }
}

explore: ref_magasin{}

explore: ref_client_cmd {}
explore: suivi_rcu {
  join: ref_magasin {
    relationship: one_to_many
    sql_on: ${ref_magasin.cd_magasin} = ${suivi_rcu.store_code} ;;
  }
}

explore: suivi_fid {
  join: ref_magasin {
    relationship: one_to_many
    sql_on: ${ref_magasin.cd_magasin} = ${suivi_fid.store_fid} ;;
  }
}

explore: suivi_ticket {}

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

explore: pdt_famille_2 {} # Pour data studio

explore: data_quality_ventes_google_sheet {}

explore: sql_runner_query {}

explore: tableau_mensuel_optin {}
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
    sql_on: ${ventes_devise.cd_acteur}=${magasins.cd_magasin} ;;
  }
}

explore: tract {
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${tract.CodeActeur}=${magasins.cd_magasin} ;;
  }
}

explore: article_dwh{
  label: "Stock actuel"
  join: magasins {
    type: cross
    relationship: many_to_many
  }
  join: article_arbo {
    type: left_outer
    relationship: many_to_one
    sql_on: ${article_arbo.cd_article}=${article_dwh.c_article} ;;
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
    type: inner
    relationship: many_to_one
    sql_on: ${stock_utd.CodeActeur}=${magasins.cd_magasin}
    AND  ${stock_utd.CodeArticle}=${article_dwh.c_article};;
  }

}

explore: web_commandes {
  label: "Web"
  join: web_clients {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_commandes.Code_Territoire} = ${web_clients.code_territoire} AND ${web_commandes.customer_id} = ${web_clients.customer_id}  ;;
  }
  join: web_articles {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_commandes.cd_produit} = ${web_articles.c_Article} ;;
  }
  join: web_arbo {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_commandes.cd_produit} = ${web_arbo.CodeArticle} ;;
  }
  join: web_magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${web_commandes.cd_magasin} = ${web_magasins.CD_Magasin} ;;
  }
}

explore:  monitoring {}

explore:  stock_histo{
  label: "Stock historisé"
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${magasins.cd_magasin} = ${stock_histo.cd_acteur} ;;
  }
  join: article_dwh{
    type: left_outer
    relationship: many_to_one
    sql_on: ${article_dwh.c_article}= ${stock_histo.cd_article} ;;
  }
  join: article_arbo {
    type: left_outer
    relationship: many_to_one
    sql_on: ${article_arbo.cd_article}=${article_dwh.c_article} ;;
  }

  join: four_dwh {
    view_label: "Fournisseurs"
    type: left_outer
    relationship: many_to_one
    sql_on: ${four_dwh.c_fournisseur}=${article_dwh.c_fournisseur} ;;
  }
  join: marques {
    type: left_outer
    relationship: many_to_one
    sql_on: ${marques.cd_marque}=${article_dwh.c_marque} ;;
  }
  #join: tf_vente {
  #  type: left_outer
  #  relationship: one_to_many
  #  sql_on: ${tf_vente.cd_article} = ${stock_histo.cd_article}
  #  AND ${tf_vente.dte_vte_date} = ${stock_histo.date_stock_date}
  #  AND ${tf_vente.cd_magasin} = ${stock_histo.cd_acteur};;
  #}
}
