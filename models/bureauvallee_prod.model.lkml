connection: "bigquery_prod"

# include all the views
include: "/views/**/*.view"
# include: "dashboards/*.dashboard.lookml"
fiscal_month_offset: 3

datagroup: bv_vente_datagroup {
  sql_trigger: SELECT count(*) FROM tf_vente ;;
  max_cache_age: "24 hour"
}

datagroup: bv_vente_digitale_datagroup {
   sql_trigger: SELECT count(*) FROM commandes ;;
  max_cache_age: "24 hour"
}

persist_with: bv_vente_datagroup

explore: pdt_tbe {}

explore: tbe_table {}

explore: vue_data_tbe {}


explore: pdt_ventes_mag {
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${pdt_ventes_mag.cd_site_ext}=${magasins.cd_logiciel} ;;
  }
  join: pdt_commandes {
    type: left_outer
    relationship: one_to_one
    sql_on: ${magasins.cd_magasin}=${pdt_commandes.cd_magasin} ;;
  }
}


explore: pdt_vente {
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${pdt_vente.cd_site_ext}=${magasins.cd_logiciel} ;;
  }
  join: pdt_commandes {
    type: left_outer
    relationship: many_to_many
    sql_on: ${magasins.cd_magasin}=${pdt_commandes.cd_magasin} ;;
  }
}

explore: pdt_vente_mag {
  join: magasins {
    type: left_outer
    relationship: many_to_many
    sql_on: ${pdt_vente_mag.cd_site_ext}=${magasins.cd_logiciel} ;;
  }
  join: pdt_commandes {
    type: left_outer
    relationship: many_to_many
    sql_on: ${magasins.cd_magasin}=${pdt_commandes.cd_magasin} ;;
  }
}

explore: pdt_commandes_digitales {
  persist_with: bv_vente_digitale_datagroup
}


explore: pdt_data_quality {
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${pdt_data_quality.cd_site_ext}=${magasins.cd_logiciel} ;;
  }
}

explore: tf_vente_mag {
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${tf_vente_mag.cd_site_ext}=${magasins.cd_logiciel} ;;
  }
  join: pdt_commandes {
    type: left_outer
    relationship: one_to_one
    sql_on: ${magasins.cd_magasin}=${pdt_commandes.cd_magasin} ;;
  }
}

explore: ventes_devise {
  join: magasins {
    type: left_outer
    relationship: many_to_one
    sql_on: ${ventes_devise.cd_magasin}=${magasins.cd_logiciel} ;;
  }
}

explore: google_sheet {}

explore: commandes {}

explore: magasins {}
