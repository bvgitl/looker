view: pdt {
  derived_table: {
    sql: SELECT distinct
       a.ID_ARTICLE_TFVTE as article,
       a.LibArticle as designation,
       a.STATUT_ART as Statut_article,
       a.TYP_ARTICLE as Typ_article,
       a.CLASS_ENERGIE as Note_ecologique,
       a.Gencod as Gencode,
       n4.Niveau4 as Niveau_4,
       n3.SousFamille as N3_SS_Famille,
       n2.Famille as N2_Famille,
       n1.Division as N1_Division,
       m.Nom_TBE as NOM,
       m.Type_TBE as Typ ,
       m.DATE_OUV as Dte_Ouverture,
       m.Pays_TBE as Pays ,
       m.Animateur as Animateur,
       m.Region as Region ,
       m.SURF_VTE as Surface ,
       m.TYP_MAG as TYP_MAG,
       m.Tranche_age as Anciennete,
       m.CD_Magasin as CD_Magasin,
       v.Dte_Vte as Dte_Vte,
       v.Typ_Vente as Typ_Vente ,
       v.Qtite as Qtite,
       v.ca_ht as ca_ht,
       v.marge_brute as marge_brute,
       mag.nb_ticket as nb_ticket,
       mq.LB_MARQUE as Marque,
       f.l_Fournisseur as Fournisseur,
       t.Qte_tracts as Qte_tracts,
       t.Mise_en_avant_web as web,
       t.E_mail as E_mail,
       t.SMS as SMS,
       t.Booster_Bonial as Booster_Bonial,
       t.Spot_RadioShop as Spot_RadioShop,
       t.PLV_Moyen_Kit as PLV_Moyen_Kit,
       t.PLV_Grand_Kit as PLV_Grand_Kit

FROM  (

(select
        RIGHT(CONCAT('000', CD_Site_Ext),3)  as CD_Site_Ext ,
        Dte_Vte ,
        Typ_Vente ,
        CD_Article,
        sum(Val_Achat_Gbl) as Val_Achat_Gbl ,
        sum(Qtite) as Qtite ,
        sum(ca_ht) as ca_ht ,
        sum(marge_brute) as marge_brute
from `bv-prod.Matillion_Perm_Table.TF_VENTE`
group by 1,2,3,4

      UNION ALL

select
        RIGHT(CONCAT('000', CD_SITE_EXT),3)  as CD_Site_Ext ,
        DTE_VENTE ,
        TYP_VENTE ,
        ID_ARTICLE,
        sum(VAL_ACHAT_GBL) as Val_Achat_Gbl ,
        sum(QTITE) as Qtite ,
        sum(CA_HT) as ca_ht,
        sum(MARGE_BRUTE) as marge_brute
from `bv-prod.Matillion_Perm_Table.GOOGLE_SHEET`
group by 1,2,3,4) v


LEFT JOIN


(
    select
    RIGHT(CONCAT('000', CD_Site_Ext),3)  as CD_Site_Ext ,
    Dte_Vte,
    Typ_vente,
    sum(nb_ticket) as nb_ticket
    from `bv-prod.Matillion_Perm_Table.TF_VENTE_MAG`
    group by 1,2,3
  ) mag

  ON  v.CD_Site_Ext = mag.CD_Site_Ext

  AND  v.Dte_Vte = mag.Dte_Vte

  AND v.Typ_vente = mag.Typ_vente )

LEFT JOIN   `bv-prod.Matillion_Perm_Table.Magasins` m

ON   v.CD_Site_Ext = m.cd_logiciel

LEFT JOIN  `bv-prod.Matillion_Perm_Table.ARTICLE` a

ON  v.CD_Article = a.ID_ARTICLE_TFVTE

LEFT JOIN `bv-prod.Matillion_Perm_Table.ARTICLE_ARBO` art

ON CAST(a.ID_ARTICLE_TFVTE as INT64) = art.ID_ARTICLE

LEFT JOIN `bv-prod.Matillion_Perm_Table.N4`  n4

ON art.ID_N4_N4 = n4.ID_N4_N4

LEFT JOIN `bv-prod.Matillion_Perm_Table.N3_SS_Famille` n3

ON  n4.ID_N3_SSFAMILLE = n3.ID_N3_SSFAMILLE

LEFT JOIN `bv-prod.Matillion_Perm_Table.N2_Famille` n2

ON  n3.ID_N2_FAMILLE = n2.ID_N2_FAMILLE

LEFT JOIN `bv-prod.Matillion_Perm_Table.N1_Division` n1

ON  n2.ID_N1_DIVISION = n1.ID_N1_DIVISION

LEFT JOIN  `bv-prod.Matillion_Perm_Table.Marques` mq

ON a.ID_MARQUE = mq.cd_marque

LEFT JOIN `bv-prod.Matillion_Perm_Table.FOUR_DWH` f

ON   a.ID_FOURN = CAST(f.c_fournisseur AS STRING)

LEFT JOIN

(
        SELECT
               code_bv,
               Mise_en_avant_web,
               E_mail,
               SMS,
               Booster_Bonial,
               Spot_RadioShop,
               PLV_Moyen_Kit,
               PLV_Grand_Kit,
               sum(Qt_tracts) as Qte_tracts
               FROM `bv-prod.Matillion_Temp_Table.TRACTS`
               GROUP BY 1,2,3,4,5,6,7,8 ) t
ON  m.cd_magasin = t.code_bv
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: article {
    type: string
    sql: ${TABLE}.article ;;
  }

  dimension: designation {
    type: string
    sql: ${TABLE}.designation ;;
  }

  dimension: statut_article {
    type: string
    sql: ${TABLE}.Statut_article ;;
  }

  dimension: typ_article {
    type: string
    sql: ${TABLE}.Typ_article ;;
  }

  dimension: note_ecologique {
    type: string
    sql: ${TABLE}.Note_ecologique ;;
  }

  dimension: gencode {
    type: string
    sql: ${TABLE}.Gencode ;;
  }

  dimension: niveau_4 {
    type: string
    sql: ${TABLE}.Niveau_4 ;;
  }

  dimension: n3_ss_famille {
    type: string
    sql: ${TABLE}.N3_SS_Famille ;;
  }

  dimension: n2_famille {
    type: string
    sql: ${TABLE}.N2_Famille ;;
  }

  dimension: n1_division {
    type: string
    sql: ${TABLE}.N1_Division ;;
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.NOM ;;
  }

  dimension: typ {
    type: string
    sql: ${TABLE}.Typ ;;
  }

  dimension: dte_ouverture {
    type: date
    datatype: date
    sql: ${TABLE}.Dte_Ouverture ;;
  }

  dimension: pays {
    type: string
    sql: ${TABLE}.Pays ;;
  }

  dimension: animateur {
    type: string
    sql: ${TABLE}.Animateur ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
  }

  dimension: surface {
    type: number
    sql: ${TABLE}.Surface ;;
  }

  dimension: typ_mag {
    type: string
    sql: ${TABLE}.TYP_MAG ;;
  }

  dimension: anciennete {
    type: string
    sql: ${TABLE}.Anciennete ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
  }

  dimension: dte_vte {
    type: date
    datatype: date
    sql: ${TABLE}.Dte_Vte ;;
  }

  dimension: typ_vente {
    type: number
    sql: ${TABLE}.Typ_Vente ;;
  }

  dimension: qtite {
    type: number
    sql: ${TABLE}.Qtite ;;
  }

  dimension: ca_ht {
    type: number
    sql: ${TABLE}.ca_ht ;;
  }

  dimension: marge_brute {
    type: number
    sql: ${TABLE}.marge_brute ;;
  }

  dimension: nb_ticket {
    type: number
    sql: ${TABLE}.nb_ticket ;;
  }

  dimension: marque {
    type: string
    sql: ${TABLE}.Marque ;;
  }

  dimension: fournisseur {
    type: string
    sql: ${TABLE}.Fournisseur ;;
  }

  dimension: qte_tracts {
    type: number
    sql: ${TABLE}.Qte_tracts ;;
  }

  dimension: web {
    type: number
    sql: ${TABLE}.web ;;
  }

  dimension: e_mail {
    type: number
    sql: ${TABLE}.E_mail ;;
  }

  dimension: sms {
    type: number
    sql: ${TABLE}.SMS ;;
  }

  dimension: booster_bonial {
    type: number
    sql: ${TABLE}.Booster_Bonial ;;
  }

  dimension: spot_radio_shop {
    type: number
    sql: ${TABLE}.Spot_RadioShop ;;
  }

  dimension: plv_moyen_kit {
    type: number
    sql: ${TABLE}.PLV_Moyen_Kit ;;
  }

  dimension: plv_grand_kit {
    type: number
    sql: ${TABLE}.PLV_Grand_Kit ;;
  }

  set: detail {
    fields: [
      article,
      designation,
      statut_article,
      typ_article,
      note_ecologique,
      gencode,
      niveau_4,
      n3_ss_famille,
      n2_famille,
      n1_division,
      nom,
      typ,
      dte_ouverture,
      pays,
      animateur,
      region,
      surface,
      typ_mag,
      anciennete,
      cd_magasin,
      dte_vte,
      typ_vente,
      qtite,
      ca_ht,
      marge_brute,
      nb_ticket,
      marque,
      fournisseur,
      qte_tracts,
      web,
      e_mail,
      sms,
      booster_bonial,
      spot_radio_shop,
      plv_moyen_kit,
      plv_grand_kit
    ]
  }
}
