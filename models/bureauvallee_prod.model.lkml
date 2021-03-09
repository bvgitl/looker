connection: "bigquery_prod"

# include all the views
include: "/views/**/*.view"
# include: "dashboards/*.dashboard.lookml"
fiscal_month_offset: 3

datagroup: bureauvallee_dev_default_datagroup {
  sql_trigger: SELECT count(*) FROM tf_vente ;;
  max_cache_age: "24 hour"
}

persist_with: bureauvallee_dev_default_datagroup

explore: dv_vente {
  join: magasin {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dv_vente.id_magasin}=${magasin.id_magasin} ;;
  }

  join: dv_web {
    type: left_outer
    relationship: many_to_one
    sql_on: ${magasin.cd_magasin}=${dv_web.code_magasin} ;;
  }
}


explore: table_update {}

explore: tf_vente_update {
  join: dv_web {
    type: left_outer
    relationship: one_to_one
    sql_on: ${tf_vente_update.cd_magasin}=${dv_web.code_magasin} ;;
  }
}

explore: google_sheet {}

explore: vte_mag {
  join: dv_web {
    type: left_outer
    relationship: many_to_one
    sql_on: ${vte_mag.cd_magasin}=${dv_web.code_magasin} ;;
  }
}

explore: dv_web {}

explore: ventes_devise {}

explore: tf_vente_corr {}

explore: all_emails {}

explore: arbo {}

explore: article {}

explore: article_arbo {}

explore: clients {}

explore: clients_ca {}

explore: clients_ca_str {}

explore: clients_retail {}

explore: dataquality_tf_vente2020 {
  join: magasin {
    type: inner
    relationship: many_to_one
    sql_on: ${magasin.id_magasin}=${dataquality_tf_vente2020.id_magasin} ;;
  }
}

explore: dataquality_tf_vente2020_donnees_remontees {}

explore: dig_campagne_20200802 {}

explore: dig_campagne_20200901 {}

explore: dig_clients {}

explore: dig_clients_connexions {}

explore: dig_commandes {
  join: dig_clients {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dig_commandes.code_client} = cast(${dig_clients.code_client} as string);;
  }

  join: dig_nos_magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dig_commandes.code_magasin} = ${dig_nos_magasins.code_magasin};;
  }
}

explore: dig_nos_magasins {}

explore: dig_produits_commandes {}

explore: magasin {}

explore: marque {}

explore: n1_division {}

explore: n2_famille {}

explore: n3_ss_famille {}

explore: n4 {}

explore: patch_abe {}

explore: tb_optim_vente {}

explore: tf_vente {
  join: google_sheet {
    type: left_outer
    relationship: one_to_one
    sql_on:  ${tf_vente.id_tf_vte}=${google_sheet.id_tf_vte};;
  }
}
