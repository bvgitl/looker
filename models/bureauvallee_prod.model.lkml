connection: "bigquery_prod"

# include all the views
include: "/views/**/*.view"

datagroup: bureauvallee_prod_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: bureauvallee_prod_default_datagroup

explore: all_emails {}

explore: arbo {}

explore: article {}

explore: article_arbo {}

explore: clients {}

explore: clients_ca {}

explore: clients_ca_str {}

explore: clients_retail {}

explore: dataquality_tf_vente2020 {}

explore: dataquality_tf_vente2020_donnees_remontees {}

explore: dig_campagne_20200802 {}

explore: dig_campagne_20200901 {}

explore: dig_clients {}

explore: dig_clients_connexions {}

explore: dig_commandes {}

explore: dig_nos_magasins {}

explore: dig_produits_commandes {}

explore: fournisseur {}

explore: magasin {}

explore: marque {}

explore: n1_division {}

explore: n2_famille {}

explore: n3_ss_famille {}

explore: n4 {}

explore: patch_abe {}

explore: tb_optim_vente {}

explore: tf_vente {}

explore: tf_vente_corr {}

explore: ventes_devise {}
