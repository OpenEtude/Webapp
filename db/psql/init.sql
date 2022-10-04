--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.5
-- Dumped by pg_dump version 9.6.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;


\connect #dbname#

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

-- CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

-- COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: acte; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE acte (
    id bigint NOT NULL,
    version bigint NOT NULL,
    date_creation timestamp without time zone NOT NULL,
    document bytea,
    dossier_id bigint NOT NULL,
    libelle character varying(1500) NOT NULL,
    modele boolean,
    num_repertoire integer NOT NULL
);


ALTER TABLE acte OWNER TO #dbname#;

--
-- Name: activity; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE activity (
    id bigint NOT NULL,
    version bigint NOT NULL,
    controller_id integer NOT NULL,
    date_created timestamp without time zone NOT NULL,
    entity_id integer NOT NULL,
    msg character varying(1500),
    op_type integer NOT NULL,
    activity_user character varying(1500) NOT NULL
);


ALTER TABLE activity OWNER TO #dbname#;

--
-- Name: bien; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE bien (
    id bigint NOT NULL,
    version bigint NOT NULL,
    dossier_id bigint,
    libelle character varying(1500) NOT NULL,
    operation_id bigint NOT NULL,
    type_de_bien_id bigint NOT NULL
);


ALTER TABLE bien OWNER TO #dbname#;

--
-- Name: categorie_ecriture; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE categorie_ecriture (
    id bigint NOT NULL,
    version bigint NOT NULL,
    libelle character varying(1500) NOT NULL
);


ALTER TABLE categorie_ecriture OWNER TO #dbname#;

--
-- Name: champ; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE champ (
    id bigint NOT NULL,
    version bigint NOT NULL,
    default_value character varying(1500),
    description character varying(1500),
    format character varying(1500),
    libelle character varying(1500) NOT NULL,
    ordre integer NOT NULL,
    setting_type character varying(7) NOT NULL,
    type_de_bien_id bigint NOT NULL
);


ALTER TABLE champ OWNER TO #dbname#;

--
-- Name: civilite; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE civilite (
    id bigint NOT NULL,
    version bigint NOT NULL,
    libelle character varying(1500) NOT NULL
);


ALTER TABLE civilite OWNER TO #dbname#;

--
-- Name: client; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE client (
    id bigint NOT NULL,
    version bigint NOT NULL,
    addresse1 character varying(1500),
    addresse2 character varying(1500),
    civilite_id bigint NOT NULL,
    commentaire character varying(1500),
    email character varying(1500),
    fax character varying(1500),
    mobile character varying(1500),
    nom character varying(1500) NOT NULL,
    num_identite character varying(1500),
    piece_identite_id bigint,
    telephone character varying(1500),
    ville character varying(1500)
);


ALTER TABLE client OWNER TO #dbname#;

--
-- Name: compte; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE compte (
    id bigint NOT NULL,
    version bigint NOT NULL,
    code character varying(1500) NOT NULL,
    compte_de_rattachement_id bigint,
    description character varying(1500),
    libelle character varying(1500) NOT NULL
);


ALTER TABLE compte OWNER TO #dbname#;

--
-- Name: compte_bancaire; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE compte_bancaire (
    id bigint NOT NULL,
    version bigint NOT NULL,
    agence character varying(1500),
    commentaire character varying(1500),
    contact character varying(1500),
    date_cloture timestamp without time zone,
    date_creation timestamp without time zone NOT NULL,
    fax character varying(1500),
    libelle character varying(1500) NOT NULL,
    rib character varying(1500),
    telephone character varying(1500)
);


ALTER TABLE compte_bancaire OWNER TO #dbname#;

--
-- Name: database_patch; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE database_patch (
    id bigint NOT NULL,
    version bigint NOT NULL,
    date_created timestamp without time zone NOT NULL,
    description character varying(1500),
    major_version integer NOT NULL,
    mid_version integer NOT NULL,
    minor_version integer NOT NULL,
    name character varying(1500) NOT NULL
);


ALTER TABLE database_patch OWNER TO #dbname#;

--
-- Name: dossier; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE dossier (
    id bigint NOT NULL,
    version bigint NOT NULL,
    cloture boolean,
    date_creation timestamp without time zone NOT NULL,
    description character varying(1500),
    etat_modele_id bigint,
    keep_montant boolean,
    libelle character varying(1500) NOT NULL,
    modele boolean,
    nom_modele character varying(1500),
    numero bigint NOT NULL,
    numero_dossier character varying(1500) NOT NULL,
    operation_id bigint
);


ALTER TABLE dossier OWNER TO #dbname#;

--
-- Name: ecriture; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE ecriture (
    id bigint NOT NULL,
    version bigint NOT NULL,
    commentaire character varying(1500),
    compte_bancaire_id bigint,
    date_mouvement timestamp without time zone,
    date_valeur timestamp without time zone NOT NULL,
    date_validation timestamp without time zone,
    etat_id bigint NOT NULL,
    marked boolean,
    modele boolean,
    montant numeric(19,2),
    moyen_paiement_id bigint,
    piece_comptable character varying(1500),
    type_ecriture_id bigint NOT NULL,
    class character varying(1500) NOT NULL,
    acte_id bigint,
    dossier_id bigint
);


ALTER TABLE ecriture OWNER TO #dbname#;

--
-- Name: etat_ecriture; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE etat_ecriture (
    id bigint NOT NULL,
    version bigint NOT NULL,
    libelle character varying(1500) NOT NULL
);


ALTER TABLE etat_ecriture OWNER TO #dbname#;

--
-- Name: groupement; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE groupement (
    id bigint NOT NULL,
    version bigint NOT NULL,
    libelle character varying(1500) NOT NULL
);


ALTER TABLE groupement OWNER TO #dbname#;

--
-- Name: jsec_permission; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE jsec_permission (
    id bigint NOT NULL,
    version bigint NOT NULL,
    possible_actions character varying(1500) NOT NULL,
    type character varying(1500) NOT NULL
);


ALTER TABLE jsec_permission OWNER TO #dbname#;

--
-- Name: jsec_role; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE jsec_role (
    id bigint NOT NULL,
    version bigint NOT NULL,
    name character varying(1500) NOT NULL
);


ALTER TABLE jsec_role OWNER TO #dbname#;

--
-- Name: jsec_role_permission_rel; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE jsec_role_permission_rel (
    id bigint NOT NULL,
    version bigint NOT NULL,
    actions character varying(1500) NOT NULL,
    permission_id bigint NOT NULL,
    role_id bigint NOT NULL,
    target character varying(1500) NOT NULL
);


ALTER TABLE jsec_role_permission_rel OWNER TO #dbname#;

--
-- Name: jsec_user; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE jsec_user (
    id bigint NOT NULL,
    version bigint NOT NULL,
    password_hash character varying(1500) NOT NULL,
    username character varying(1500) NOT NULL
);


ALTER TABLE jsec_user OWNER TO #dbname#;

--
-- Name: jsec_user_permission_rel; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE jsec_user_permission_rel (
    id bigint NOT NULL,
    version bigint NOT NULL,
    actions character varying(1500) NOT NULL,
    permission_id bigint NOT NULL,
    target character varying(1500),
    user_id bigint NOT NULL
);


ALTER TABLE jsec_user_permission_rel OWNER TO #dbname#;

--
-- Name: jsec_user_role_rel; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE jsec_user_role_rel (
    id bigint NOT NULL,
    version bigint NOT NULL,
    role_id bigint NOT NULL,
    user_id bigint NOT NULL
);


ALTER TABLE jsec_user_role_rel OWNER TO #dbname#;

--
-- Name: moyen_paiement; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE moyen_paiement (
    id bigint NOT NULL,
    version bigint NOT NULL,
    libelle character varying(1500) NOT NULL
);


ALTER TABLE moyen_paiement OWNER TO #dbname#;

--
-- Name: operation; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE operation (
    id bigint NOT NULL,
    version bigint NOT NULL,
    client_id bigint NOT NULL,
    date_creation timestamp without time zone NOT NULL,
    description character varying(1500),
    libelle character varying(1500) NOT NULL
);


ALTER TABLE operation OWNER TO #dbname#;

--
-- Name: piece_identite; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE piece_identite (
    id bigint NOT NULL,
    version bigint NOT NULL,
    libelle character varying(1500) NOT NULL
);


ALTER TABLE piece_identite OWNER TO #dbname#;

--
-- Name: seq_acte; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_acte
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_acte OWNER TO #dbname#;

--
-- Name: seq_activity; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_activity
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_activity OWNER TO #dbname#;

--
-- Name: seq_bien; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_bien
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_bien OWNER TO #dbname#;

--
-- Name: seq_categorie_ecriture; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_categorie_ecriture
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_categorie_ecriture OWNER TO #dbname#;

--
-- Name: seq_champ; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_champ
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_champ OWNER TO #dbname#;

--
-- Name: seq_civilite; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_civilite
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_civilite OWNER TO #dbname#;

--
-- Name: seq_client; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_client
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_client OWNER TO #dbname#;

--
-- Name: seq_compte; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_compte
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_compte OWNER TO #dbname#;

--
-- Name: seq_compte_bancaire; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_compte_bancaire
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_compte_bancaire OWNER TO #dbname#;

--
-- Name: seq_database_patch; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_database_patch
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_database_patch OWNER TO #dbname#;

--
-- Name: seq_dossier; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_dossier
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_dossier OWNER TO #dbname#;

--
-- Name: seq_ecriture; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_ecriture
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_ecriture OWNER TO #dbname#;

--
-- Name: seq_etat_ecriture; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_etat_ecriture
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_etat_ecriture OWNER TO #dbname#;

--
-- Name: seq_groupement; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_groupement
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_groupement OWNER TO #dbname#;

--
-- Name: seq_jsec_permission; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_jsec_permission
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_jsec_permission OWNER TO #dbname#;

--
-- Name: seq_jsec_role; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_jsec_role
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_jsec_role OWNER TO #dbname#;

--
-- Name: seq_jsec_role_permission_rel; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_jsec_role_permission_rel
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_jsec_role_permission_rel OWNER TO #dbname#;

--
-- Name: seq_jsec_user; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_jsec_user
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_jsec_user OWNER TO #dbname#;

--
-- Name: seq_jsec_user_permission_rel; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_jsec_user_permission_rel
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_jsec_user_permission_rel OWNER TO #dbname#;

--
-- Name: seq_jsec_user_role_rel; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_jsec_user_role_rel
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_jsec_user_role_rel OWNER TO #dbname#;

--
-- Name: seq_moyen_paiement; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_moyen_paiement
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_moyen_paiement OWNER TO #dbname#;

--
-- Name: seq_operation; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_operation
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_operation OWNER TO #dbname#;

--
-- Name: seq_piece_identite; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_piece_identite
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_piece_identite OWNER TO #dbname#;

--
-- Name: seq_setting; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_setting
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_setting OWNER TO #dbname#;

--
-- Name: seq_software_update; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_software_update
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_software_update OWNER TO #dbname#;

--
-- Name: seq_tag_links; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_tag_links
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_tag_links OWNER TO #dbname#;

--
-- Name: seq_tags; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_tags
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_tags OWNER TO #dbname#;

--
-- Name: seq_traduction; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_traduction
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_traduction OWNER TO #dbname#;

--
-- Name: seq_type_de_bien; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_type_de_bien
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_type_de_bien OWNER TO #dbname#;

--
-- Name: seq_type_ecriture; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_type_ecriture
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_type_ecriture OWNER TO #dbname#;

--
-- Name: seq_type_ecriture_groupement_rel; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_type_ecriture_groupement_rel
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_type_ecriture_groupement_rel OWNER TO #dbname#;

--
-- Name: seq_valeur; Type: SEQUENCE; Schema: public; Owner: #dbname#
--

CREATE SEQUENCE seq_valeur
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_valeur OWNER TO #dbname#;

--
-- Name: setting; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE setting (
    id bigint NOT NULL,
    version bigint NOT NULL,
    category character varying(1500),
    default_value character varying(1500),
    editor character varying(1500),
    key character varying(1500) NOT NULL,
    permission_actions character varying(1500),
    permission_target character varying(1500),
    permission_type character varying(1500),
    rank integer,
    setting_type character varying(7) NOT NULL,
    user_id bigint,
    value character varying(1500)
);


ALTER TABLE setting OWNER TO #dbname#;

--
-- Name: software_update; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE software_update (
    id bigint NOT NULL,
    version bigint NOT NULL,
    archived boolean NOT NULL,
    auto_install boolean NOT NULL,
    changelog character varying(1500) NOT NULL,
    download_date timestamp without time zone NOT NULL,
    file_size bigint NOT NULL,
    fingerprint character varying(1500) NOT NULL,
    installation_date timestamp without time zone,
    installed boolean NOT NULL,
    release_date timestamp without time zone NOT NULL,
    release_version character varying(1500) NOT NULL
);


ALTER TABLE software_update OWNER TO #dbname#;

--
-- Name: tag_links; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE tag_links (
    id bigint NOT NULL,
    version bigint NOT NULL,
    tag_id bigint NOT NULL,
    tag_ref bigint NOT NULL,
    type character varying(1500) NOT NULL
);


ALTER TABLE tag_links OWNER TO #dbname#;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE tags (
    id bigint NOT NULL,
    version bigint NOT NULL,
    applies_to character varying(1500),
    name character varying(1500) NOT NULL
);


ALTER TABLE tags OWNER TO #dbname#;

--
-- Name: traduction; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE traduction (
    id bigint NOT NULL,
    version bigint NOT NULL,
    description character varying(1500) NOT NULL,
    name character varying(1500) NOT NULL,
    trad character varying(1500) NOT NULL
);


ALTER TABLE traduction OWNER TO #dbname#;

--
-- Name: type_de_bien; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE type_de_bien (
    id bigint NOT NULL,
    version bigint NOT NULL,
    libelle character varying(1500) NOT NULL
);


ALTER TABLE type_de_bien OWNER TO #dbname#;

--
-- Name: type_ecriture; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE type_ecriture (
    id bigint NOT NULL,
    version bigint NOT NULL,
    affectable boolean,
    affiche_dans_operation integer,
    categorie_ecriture_id bigint NOT NULL,
    compteacrediter_id bigint,
    compteadebiter_id bigint,
    credit boolean NOT NULL,
    libelle character varying(1500) NOT NULL
);


ALTER TABLE type_ecriture OWNER TO #dbname#;

--
-- Name: type_ecriture_groupement_rel; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE type_ecriture_groupement_rel (
    id bigint NOT NULL,
    version bigint NOT NULL,
    groupement_id bigint NOT NULL,
    type_ecriture_id bigint NOT NULL
);


ALTER TABLE type_ecriture_groupement_rel OWNER TO #dbname#;

--
-- Name: valeur; Type: TABLE; Schema: public; Owner: #dbname#
--

CREATE TABLE valeur (
    id bigint NOT NULL,
    version bigint NOT NULL,
    bien_id bigint NOT NULL,
    champ_id bigint NOT NULL,
    contenu character varying(1500)
);


ALTER TABLE valeur OWNER TO #dbname#;

--
-- Name: acte acte_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY acte
    ADD CONSTRAINT acte_pkey PRIMARY KEY (id);


--
-- Name: activity activity_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY activity
    ADD CONSTRAINT activity_pkey PRIMARY KEY (id);


--
-- Name: bien bien_libelle_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY bien
    ADD CONSTRAINT bien_libelle_key UNIQUE (libelle);


--
-- Name: bien bien_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY bien
    ADD CONSTRAINT bien_pkey PRIMARY KEY (id);


--
-- Name: categorie_ecriture categorie_ecriture_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY categorie_ecriture
    ADD CONSTRAINT categorie_ecriture_pkey PRIMARY KEY (id);


--
-- Name: champ champ_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY champ
    ADD CONSTRAINT champ_pkey PRIMARY KEY (id);


--
-- Name: champ champ_type_de_bien_id_ordre_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY champ
    ADD CONSTRAINT champ_type_de_bien_id_ordre_key UNIQUE (type_de_bien_id, ordre);


--
-- Name: civilite civilite_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY civilite
    ADD CONSTRAINT civilite_pkey PRIMARY KEY (id);


--
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY client
    ADD CONSTRAINT client_pkey PRIMARY KEY (id);


--
-- Name: compte_bancaire compte_bancaire_libelle_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY compte_bancaire
    ADD CONSTRAINT compte_bancaire_libelle_key UNIQUE (libelle);


--
-- Name: compte_bancaire compte_bancaire_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY compte_bancaire
    ADD CONSTRAINT compte_bancaire_pkey PRIMARY KEY (id);


--
-- Name: compte_bancaire compte_bancaire_rib_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY compte_bancaire
    ADD CONSTRAINT compte_bancaire_rib_key UNIQUE (rib);


--
-- Name: compte compte_code_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY compte
    ADD CONSTRAINT compte_code_key UNIQUE (code);


--
-- Name: compte compte_compte_de_rattachement_id_libelle_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY compte
    ADD CONSTRAINT compte_compte_de_rattachement_id_libelle_key UNIQUE (compte_de_rattachement_id, libelle);


--
-- Name: compte compte_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY compte
    ADD CONSTRAINT compte_pkey PRIMARY KEY (id);


--
-- Name: database_patch database_patch_name_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY database_patch
    ADD CONSTRAINT database_patch_name_key UNIQUE (name);


--
-- Name: database_patch database_patch_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY database_patch
    ADD CONSTRAINT database_patch_pkey PRIMARY KEY (id);


--
-- Name: dossier dossier_numero_dossier_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY dossier
    ADD CONSTRAINT dossier_numero_dossier_key UNIQUE (numero_dossier);


--
-- Name: dossier dossier_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY dossier
    ADD CONSTRAINT dossier_pkey PRIMARY KEY (id);


--
-- Name: ecriture ecriture_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY ecriture
    ADD CONSTRAINT ecriture_pkey PRIMARY KEY (id);


--
-- Name: etat_ecriture etat_ecriture_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY etat_ecriture
    ADD CONSTRAINT etat_ecriture_pkey PRIMARY KEY (id);


--
-- Name: groupement groupement_libelle_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY groupement
    ADD CONSTRAINT groupement_libelle_key UNIQUE (libelle);


--
-- Name: groupement groupement_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY groupement
    ADD CONSTRAINT groupement_pkey PRIMARY KEY (id);


--
-- Name: jsec_permission jsec_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY jsec_permission
    ADD CONSTRAINT jsec_permission_pkey PRIMARY KEY (id);


--
-- Name: jsec_permission jsec_permission_type_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY jsec_permission
    ADD CONSTRAINT jsec_permission_type_key UNIQUE (type);


--
-- Name: jsec_role jsec_role_name_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY jsec_role
    ADD CONSTRAINT jsec_role_name_key UNIQUE (name);


--
-- Name: jsec_role_permission_rel jsec_role_permission_rel_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY jsec_role_permission_rel
    ADD CONSTRAINT jsec_role_permission_rel_pkey PRIMARY KEY (id);


--
-- Name: jsec_role jsec_role_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY jsec_role
    ADD CONSTRAINT jsec_role_pkey PRIMARY KEY (id);


--
-- Name: jsec_user_permission_rel jsec_user_permission_rel_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY jsec_user_permission_rel
    ADD CONSTRAINT jsec_user_permission_rel_pkey PRIMARY KEY (id);


--
-- Name: jsec_user jsec_user_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY jsec_user
    ADD CONSTRAINT jsec_user_pkey PRIMARY KEY (id);


--
-- Name: jsec_user_role_rel jsec_user_role_rel_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY jsec_user_role_rel
    ADD CONSTRAINT jsec_user_role_rel_pkey PRIMARY KEY (id);


--
-- Name: moyen_paiement moyen_paiement_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY moyen_paiement
    ADD CONSTRAINT moyen_paiement_pkey PRIMARY KEY (id);


--
-- Name: operation operation_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT operation_pkey PRIMARY KEY (id);


--
-- Name: piece_identite piece_identite_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY piece_identite
    ADD CONSTRAINT piece_identite_pkey PRIMARY KEY (id);


--
-- Name: setting setting_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY setting
    ADD CONSTRAINT setting_pkey PRIMARY KEY (id);


--
-- Name: setting setting_user_id_key_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY setting
    ADD CONSTRAINT setting_user_id_key_key UNIQUE (user_id, key);


--
-- Name: software_update software_update_fingerprint_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY software_update
    ADD CONSTRAINT software_update_fingerprint_key UNIQUE (fingerprint);


--
-- Name: software_update software_update_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY software_update
    ADD CONSTRAINT software_update_pkey PRIMARY KEY (id);


--
-- Name: tag_links tag_links_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY tag_links
    ADD CONSTRAINT tag_links_pkey PRIMARY KEY (id);


--
-- Name: tags tags_applies_to_name_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_applies_to_name_key UNIQUE (applies_to, name);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: traduction traduction_description_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY traduction
    ADD CONSTRAINT traduction_description_key UNIQUE (description);


--
-- Name: traduction traduction_name_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY traduction
    ADD CONSTRAINT traduction_name_key UNIQUE (name);


--
-- Name: traduction traduction_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY traduction
    ADD CONSTRAINT traduction_pkey PRIMARY KEY (id);


--
-- Name: type_de_bien type_de_bien_libelle_key; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY type_de_bien
    ADD CONSTRAINT type_de_bien_libelle_key UNIQUE (libelle);


--
-- Name: type_de_bien type_de_bien_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY type_de_bien
    ADD CONSTRAINT type_de_bien_pkey PRIMARY KEY (id);


--
-- Name: type_ecriture_groupement_rel type_ecriture_groupement_rel_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY type_ecriture_groupement_rel
    ADD CONSTRAINT type_ecriture_groupement_rel_pkey PRIMARY KEY (id);


--
-- Name: type_ecriture type_ecriture_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY type_ecriture
    ADD CONSTRAINT type_ecriture_pkey PRIMARY KEY (id);


--
-- Name: valeur valeur_pkey; Type: CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY valeur
    ADD CONSTRAINT valeur_pkey PRIMARY KEY (id);


--
-- Name: dossier_idx; Type: INDEX; Schema: public; Owner: #dbname#
--

CREATE INDEX dossier_idx ON ecriture USING btree (dossier_id);


--
-- Name: typeecriture_idx; Type: INDEX; Schema: public; Owner: #dbname#
--

CREATE INDEX typeecriture_idx ON ecriture USING btree (type_ecriture_id);


--
-- Name: jsec_user_role_rel fk238f64ac73b37241; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY jsec_user_role_rel
    ADD CONSTRAINT fk238f64ac73b37241 FOREIGN KEY (user_id) REFERENCES jsec_user(id);


--
-- Name: jsec_user_role_rel fk238f64acce88ae61; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY jsec_user_role_rel
    ADD CONSTRAINT fk238f64acce88ae61 FOREIGN KEY (role_id) REFERENCES jsec_role(id);


--
-- Name: jsec_user_permission_rel fk28ff608573b37241; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY jsec_user_permission_rel
    ADD CONSTRAINT fk28ff608573b37241 FOREIGN KEY (user_id) REFERENCES jsec_user(id);


--
-- Name: jsec_user_permission_rel fk28ff6085f1eda81; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY jsec_user_permission_rel
    ADD CONSTRAINT fk28ff6085f1eda81 FOREIGN KEY (permission_id) REFERENCES jsec_permission(id);


--
-- Name: acte fk2d9a13adfd91ba; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY acte
    ADD CONSTRAINT fk2d9a13adfd91ba FOREIGN KEY (dossier_id) REFERENCES dossier(id);


--
-- Name: bien fk2e2330955cc03c; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY bien
    ADD CONSTRAINT fk2e2330955cc03c FOREIGN KEY (type_de_bien_id) REFERENCES type_de_bien(id);


--
-- Name: bien fk2e2330adfd91ba; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY bien
    ADD CONSTRAINT fk2e2330adfd91ba FOREIGN KEY (dossier_id) REFERENCES dossier(id);


--
-- Name: bien fk2e2330ca36443a; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY bien
    ADD CONSTRAINT fk2e2330ca36443a FOREIGN KEY (operation_id) REFERENCES operation(id);


--
-- Name: ecriture fk3966394930edf603; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY ecriture
    ADD CONSTRAINT fk3966394930edf603 FOREIGN KEY (etat_id) REFERENCES etat_ecriture(id);


--
-- Name: ecriture fk396639498fe4141b; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY ecriture
    ADD CONSTRAINT fk396639498fe4141b FOREIGN KEY (moyen_paiement_id) REFERENCES moyen_paiement(id);


--
-- Name: ecriture fk3966394993788d5b; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY ecriture
    ADD CONSTRAINT fk3966394993788d5b FOREIGN KEY (compte_bancaire_id) REFERENCES compte_bancaire(id);


--
-- Name: ecriture fk39663949961e550f; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY ecriture
    ADD CONSTRAINT fk39663949961e550f FOREIGN KEY (type_ecriture_id) REFERENCES type_ecriture(id);


--
-- Name: ecriture fk39663949adfd91ba; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY ecriture
    ADD CONSTRAINT fk39663949adfd91ba FOREIGN KEY (dossier_id) REFERENCES dossier(id);


--
-- Name: ecriture fk39663949badd48fa; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY ecriture
    ADD CONSTRAINT fk39663949badd48fa FOREIGN KEY (acte_id) REFERENCES acte(id);


--
-- Name: champ fk5a3d73f955cc03c; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY champ
    ADD CONSTRAINT fk5a3d73f955cc03c FOREIGN KEY (type_de_bien_id) REFERENCES type_de_bien(id);


--
-- Name: operation fk631ad5676f9c5fa; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY operation
    ADD CONSTRAINT fk631ad5676f9c5fa FOREIGN KEY (client_id) REFERENCES client(id);


--
-- Name: dossier fk6de37ecb47da13ac; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY dossier
    ADD CONSTRAINT fk6de37ecb47da13ac FOREIGN KEY (etat_modele_id) REFERENCES etat_ecriture(id);


--
-- Name: dossier fk6de37ecbca36443a; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY dossier
    ADD CONSTRAINT fk6de37ecbca36443a FOREIGN KEY (operation_id) REFERENCES operation(id);


--
-- Name: jsec_role_permission_rel fk6df5807ace88ae61; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY jsec_role_permission_rel
    ADD CONSTRAINT fk6df5807ace88ae61 FOREIGN KEY (role_id) REFERENCES jsec_role(id);


--
-- Name: jsec_role_permission_rel fk6df5807af1eda81; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY jsec_role_permission_rel
    ADD CONSTRAINT fk6df5807af1eda81 FOREIGN KEY (permission_id) REFERENCES jsec_permission(id);


--
-- Name: setting fk765f0e5073b37241; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY setting
    ADD CONSTRAINT fk765f0e5073b37241 FOREIGN KEY (user_id) REFERENCES jsec_user(id);


--
-- Name: type_ecriture fk7a295cae1c903333; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY type_ecriture
    ADD CONSTRAINT fk7a295cae1c903333 FOREIGN KEY (compteacrediter_id) REFERENCES compte(id);


--
-- Name: type_ecriture fk7a295cae412db7c2; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY type_ecriture
    ADD CONSTRAINT fk7a295cae412db7c2 FOREIGN KEY (compteadebiter_id) REFERENCES compte(id);


--
-- Name: type_ecriture fk7a295caed1a08449; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY type_ecriture
    ADD CONSTRAINT fk7a295caed1a08449 FOREIGN KEY (categorie_ecriture_id) REFERENCES categorie_ecriture(id);


--
-- Name: tag_links fk7c35d6d45a3b441d; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY tag_links
    ADD CONSTRAINT fk7c35d6d45a3b441d FOREIGN KEY (tag_id) REFERENCES tags(id);


--
-- Name: type_ecriture_groupement_rel fk984131af6e8e2b5a; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY type_ecriture_groupement_rel
    ADD CONSTRAINT fk984131af6e8e2b5a FOREIGN KEY (groupement_id) REFERENCES groupement(id);


--
-- Name: type_ecriture_groupement_rel fk984131af961e550f; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY type_ecriture_groupement_rel
    ADD CONSTRAINT fk984131af961e550f FOREIGN KEY (type_ecriture_id) REFERENCES type_ecriture(id);


--
-- Name: client fkaf12f3cb449bfe97; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY client
    ADD CONSTRAINT fkaf12f3cb449bfe97 FOREIGN KEY (piece_identite_id) REFERENCES piece_identite(id);


--
-- Name: client fkaf12f3cb760a2c7a; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY client
    ADD CONSTRAINT fkaf12f3cb760a2c7a FOREIGN KEY (civilite_id) REFERENCES civilite(id);


--
-- Name: compte fkaf3f35c08517f0cf; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY compte
    ADD CONSTRAINT fkaf3f35c08517f0cf FOREIGN KEY (compte_de_rattachement_id) REFERENCES compte(id);


--
-- Name: valeur fkcee563015937c53a; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY valeur
    ADD CONSTRAINT fkcee563015937c53a FOREIGN KEY (champ_id) REFERENCES champ(id);


--
-- Name: valeur fkcee56301f931d7da; Type: FK CONSTRAINT; Schema: public; Owner: #dbname#
--

ALTER TABLE ONLY valeur
    ADD CONSTRAINT fkcee56301f931d7da FOREIGN KEY (bien_id) REFERENCES bien(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: #dbname#
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

INSERT INTO CATEGORIE_ECRITURE VALUES(1,0,'Frais');
INSERT INTO CATEGORIE_ECRITURE VALUES(2,0,'Prix');
INSERT INTO CATEGORIE_ECRITURE VALUES(3,0,'Autre');
INSERT INTO CIVILITE VALUES(2,0,'M.');
INSERT INTO CIVILITE VALUES(3,0,'Mme');
INSERT INTO CIVILITE VALUES(4,0,'Mlle');
INSERT INTO CIVILITE VALUES(5,0,'Entreprise');
INSERT INTO COMPTE VALUES(1,0,NULL,'2107-10-16 09:53:20.406000000','2007-10-15 09:53:20.406000000',NULL,'Etude',NULL,NULL);
INSERT INTO COMPTE VALUES(2,0,1,'2107-10-16 09:53:20.437000000','2007-10-15 09:53:20.437000000',NULL,'Frais',NULL,NULL);
INSERT INTO COMPTE VALUES(3,0,1,'2107-10-16 09:53:20.437000000','2007-10-15 09:53:20.437000000',NULL,'Prix',NULL,NULL);
INSERT INTO COMPTE VALUES(5,0,1,'2107-10-16 09:53:20.453000000','2007-10-15 09:53:20.453000000',NULL,'Tiers',NULL,NULL);
INSERT INTO COMPTE VALUES(6,0,1,'2107-10-18 00:35:22.837000000','2007-10-17 00:35:22.837000000',NULL,'Comptes Financiers',NULL,NULL);
INSERT INTO ETAT_ECRITURE VALUES(1,0,'En Cours');
INSERT INTO ETAT_ECRITURE VALUES(2,1,'Valid\u00e9e');
INSERT INTO ETAT_ECRITURE VALUES(3,1,'Rejet\u00e9e');
INSERT INTO ETAT_ECRITURE VALUES(4,0,'Vide');
INSERT INTO JSEC_PERMISSION VALUES(2,0,'Liste,Consultation,Creation,Modification,Suppression','EtudePerm');
INSERT INTO JSEC_ROLE VALUES(4,0,'Maitre');
INSERT INTO JSEC_ROLE VALUES(5,0,'Comptable');
INSERT INTO JSEC_ROLE VALUES(6,0,'Stagiaire');
INSERT INTO JSEC_ROLE VALUES(7,0,'Secretaire');
INSERT INTO JSEC_ROLE VALUES(8,0,'Technicien');
INSERT INTO JSEC_ROLE VALUES(9,0,'Auditeur');
INSERT INTO JSEC_ROLE VALUES(10,0,'Visiteur');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(789,2,'Consultation,Creation,Liste,Modification,Suppression,Aucune',2,4,'Acte');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(790,3,'Consultation,Creation,Liste,Modification,Aucune',2,5,'Acte');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(791,1,'Consultation,Creation,Liste,Modification,Aucune',2,6,'Acte');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(792,2,'Consultation,Liste,Aucune',2,7,'Acte');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(793,2,'Consultation,Creation,Liste,Modification,Suppression,Aucune',2,4,'Client');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(794,3,'Consultation,Creation,Liste,Modification,Aucune',2,5,'Client');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(795,3,'Consultation,Creation,Liste,Modification,Aucune',2,6,'Client');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(796,2,'Consultation,Liste,Aucune',2,7,'Client');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(797,2,'Consultation,Creation,Liste,Modification,ModificationMasse,RapportDetail,Suppression,Aucune',2,4,'Dossier');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(798,5,'Consultation,Creation,Liste,Modification,ModificationMasse,RapportDetail,Aucune',2,5,'Dossier');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(799,4,'Consultation,Creation,Liste,Modification,RapportDetail,Aucune',2,6,'Dossier');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(800,3,'Consultation,Liste,RapportDetail,Aucune',2,7,'Dossier');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(801,1,'Consultation,Creation,Liste,Modification,ModificationMasse,RapportDetail,RapportSynthese,Suppression,Aucune',2,4,'EcritureDossier');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(802,3,'Consultation,Creation,Liste,Modification,ModificationMasse,RapportDetail,RapportSynthese,Aucune',2,5,'EcritureDossier');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(803,2,'Consultation,Creation,Liste,RapportDetail,RapportSynthese,Aucune',2,6,'EcritureDossier');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(804,3,'Consultation,Liste,RapportSynthese,Aucune',2,7,'EcritureDossier');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(805,1,'Consultation,Creation,Liste,Modification,ModificationMasse,RapportDetail,RapportSynthese,Suppression,Aucune',2,4,'Ecriture');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(806,4,'Consultation,Creation,Liste,Modification,ModificationMasse,RapportDetail,Aucune',2,5,'Ecriture');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(807,2,'Consultation,Creation,Liste,RapportDetail,Aucune',2,6,'Ecriture');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(808,3,'Aucune',2,7,'Ecriture');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(809,2,'Consultation,Creation,Liste,Modification,ModificationMasse,Suppression,Aucune',2,4,'TypeEcriture');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(810,1,'Consultation,Creation,Liste,Aucune',2,5,'TypeEcriture');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(811,1,'Consultation,Creation,Liste,Aucune',2,6,'TypeEcriture');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(812,1,'Consultation,Liste,Aucune',2,7,'TypeEcriture');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(813,0,'Liste,Consultation,Creation,Modification,Suppression',2,4,'JsecUser');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(814,0,'Liste,Consultation,Creation,Modification,Suppression',2,4,'JsecUserRoleRel');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(815,0,'Liste,Consultation,Creation,Modification,Suppression',2,4,'JsecRole');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(816,2,'Consultation,Creation,Liste,Modification,Suppression,Aucune',2,4,'Groupement');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(817,1,'Consultation,Creation,Liste,Modification,ModificationMasse,RapportDetail,RapportSynthese,Suppression,Aucune',2,4,'Setting');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(818,2,'Consultation,Creation,Liste,Modification,Suppression,Aucune',2,5,'Setting');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(819,1,'Consultation,Creation,Liste,Aucune',2,6,'Setting');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(820,1,'Consultation,Creation,Liste,Aucune',2,7,'Setting');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(821,2,'Consultation,Creation,Liste,Modification,Suppression,Aucune',2,4,'Operation');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(822,3,'Consultation,Creation,Liste,Modification,Aucune',2,5,'Operation');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(823,3,'Consultation,Creation,Liste,Aucune',2,6,'Operation');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(824,2,'Consultation,Liste,Aucune',2,7,'Operation');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(825,2,'Consultation,Creation,Liste,Modification,Suppression,Aucune',2,4,'Bien');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(826,3,'Consultation,Creation,Liste,Modification,Aucune',2,5,'Bien');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(827,3,'Consultation,Creation,Liste,Modification,Aucune',2,6,'Bien');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(828,2,'Consultation,Liste,Aucune',2,7,'Bien');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(829,2,'Consultation,Creation,Liste,Modification,Suppression,Aucune',2,4,'TypeDeBien');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(830,3,'Consultation,Creation,Liste,Modification,Aucune',2,5,'TypeDeBien');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(831,1,'Consultation,Creation,Liste,Modification,Aucune',2,6,'TypeDeBien');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(832,2,'Consultation,Liste,Aucune',2,7,'TypeDeBien');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(833,2,'Consultation,Creation,Liste,Modification,Suppression,Aucune',2,4,'Champ');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(834,3,'Consultation,Creation,Liste,Modification,Aucune',2,5,'Champ');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(835,3,'Consultation,Creation,Liste,Modification,Aucune',2,6,'Champ');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(836,2,'Consultation,Liste,Aucune',2,7,'Champ');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(837,2,'Consultation,Creation,Liste,Modification,Suppression,Aucune',2,4,'Valeur');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(838,3,'Consultation,Creation,Liste,Modification,Aucune',2,5,'Valeur');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(839,1,'Consultation,Creation,Liste,Modification,Aucune',2,6,'Valeur');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(840,2,'Consultation,Liste,Aucune',2,7,'Valeur');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(841,1,'Consultation,Liste,Aucune',2,5,'Groupement');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(842,2,'Consultation,Liste,Aucune',2,6,'Groupement');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(843,0,'Aucune',2,7,'Groupement');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(844,2,'Consultation,Creation,Liste,Modification,Suppression,Aucune',2,4,'CompteBancaire');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(845,2,'Consultation,Creation,Liste,Aucune',2,5,'CompteBancaire');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(846,3,'Consultation,Aucune',2,6,'CompteBancaire');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(847,1,'Liste,Aucune',2,7,'CompteBancaire');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(848,0,'Aucune',2,5,'JsecUser');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(849,0,'Aucune',2,6,'JsecUser');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(850,0,'Aucune',2,7,'JsecUser');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(851,0,'Aucune',2,5,'JsecUserRoleRel');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(852,0,'Aucune',2,6,'JsecUserRoleRel');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(853,0,'Aucune',2,7,'JsecUserRoleRel');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(854,0,'Aucune',2,5,'JsecRole');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(855,0,'Aucune',2,6,'JsecRole');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(856,0,'Aucune',2,7,'JsecRole');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(857,2,'Aucune',2,4,'Param');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(858,0,'Aucune',2,5,'Param');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(859,0,'Aucune',2,6,'Param');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(860,0,'Aucune',2,7,'Param');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(861,2,'Consultation,Creation,Liste,Modification,Suppression,Aucune',2,4,'Traduction');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(862,0,'Aucune',2,5,'Traduction');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(863,2,'Consultation,Creation,Liste,Aucune',2,6,'Traduction');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(864,0,'Aucune',2,7,'Traduction');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(865,2,'Consultation,Liste,Suppression,Aucune',2,4,'Activity');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(866,0,'Aucune',2,5,'Activity');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(867,0,'Aucune',2,6,'Activity');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(868,0,'Aucune',2,7,'Activity');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(869,1,'Liste,Modification,Aucune',2,4,'Administration');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(870,0,'Aucune',2,5,'Administration');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(871,0,'Aucune',2,6,'Administration');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(872,0,'Aucune',2,7,'Administration');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(873,1,'Consultation,Liste,Aucune',2,9,'Dossier');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(874,1,'Consultation,Liste,Aucune',2,10,'Dossier');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(875,1,'Aucune',2,4,'Compte');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(876,1,'Aucune',2,5,'Compte');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(877,0,'Aucune',2,8,'Setting');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(878,0,'Aucune',2,9,'Setting');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(879,0,'Aucune',2,10,'Setting');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(880,0,'Aucune',2,8,'Operation');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(881,1,'Consultation,Aucune',2,9,'Operation');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(882,1,'Consultation,Aucune',2,10,'Operation');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(883,0,'Aucune',2,8,'Client');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(884,1,'Consultation,Aucune',2,9,'Client');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(885,1,'Consultation,Aucune',2,10,'Client');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(886,0,'Aucune',2,8,'Bien');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(887,1,'Consultation,Aucune',2,9,'Bien');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(888,1,'Consultation,Aucune',2,10,'Bien');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(889,0,'Aucune',2,8,'TypeDeBien');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(890,1,'Consultation,Aucune',2,9,'TypeDeBien');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(891,1,'Consultation,Aucune',2,10,'TypeDeBien');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(892,0,'Aucune',2,8,'Champ');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(893,1,'Consultation,Aucune',2,9,'Champ');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(894,1,'Consultation,Aucune',2,10,'Champ');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(895,0,'Aucune',2,8,'Valeur');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(896,1,'Consultation,Aucune',2,9,'Valeur');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(897,1,'Consultation,Aucune',2,10,'Valeur');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(898,0,'Aucune',2,8,'EcritureDossier');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(899,1,'Consultation,Aucune',2,9,'EcritureDossier');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(900,0,'Aucune',2,10,'EcritureDossier');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(901,0,'Aucune',2,8,'Dossier');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(902,0,'Aucune',2,8,'Acte');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(903,1,'Consultation,Liste,Aucune',2,9,'Acte');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(904,0,'Aucune',2,10,'Acte');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(905,0,'Aucune',2,8,'Ecriture');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(906,0,'Aucune',2,9,'Ecriture');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(907,0,'Aucune',2,10,'Ecriture');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(908,0,'Aucune',2,8,'TypeEcriture');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(909,2,'Consultation,Aucune',2,9,'TypeEcriture');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(910,0,'Aucune',2,10,'TypeEcriture');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(911,0,'Aucune',2,8,'Groupement');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(912,2,'Consultation,Liste,Aucune',2,9,'Groupement');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(913,0,'Aucune',2,10,'Groupement');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(914,0,'Aucune',2,8,'CompteBancaire');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(915,1,'Consultation,Liste,Aucune',2,9,'CompteBancaire');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(916,0,'Aucune',2,10,'CompteBancaire');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(917,0,'Aucune',2,8,'JsecUser');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(918,0,'Aucune',2,9,'JsecUser');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(919,0,'Aucune',2,10,'JsecUser');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(920,0,'Aucune',2,8,'JsecUserRoleRel');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(921,0,'Aucune',2,9,'JsecUserRoleRel');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(922,0,'Aucune',2,10,'JsecUserRoleRel');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(923,0,'Aucune',2,8,'JsecRole');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(924,0,'Aucune',2,9,'JsecRole');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(925,0,'Aucune',2,10,'JsecRole');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(926,0,'Aucune',2,8,'Param');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(927,0,'Aucune',2,9,'Param');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(928,0,'Aucune',2,10,'Param');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(929,0,'Aucune',2,8,'Traduction');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(930,2,'Consultation,Liste,Aucune',2,9,'Traduction');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(931,0,'Aucune',2,10,'Traduction');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(932,0,'Aucune',2,8,'Activity');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(933,1,'Consultation,Aucune',2,9,'Activity');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(934,0,'Aucune',2,10,'Activity');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(935,0,'Aucune',2,8,'Administration');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(936,2,'Liste,Modification,Aucune',2,9,'Administration');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(937,0,'Aucune',2,10,'Administration');
INSERT INTO JSEC_ROLE_PERMISSION_REL VALUES(938,0,'Liste,Consultation',2,4,'SoftwareUpdate');
INSERT INTO MOYEN_PAIEMENT VALUES(1,1,'Ch\u00e8que');
INSERT INTO MOYEN_PAIEMENT VALUES(2,1,'Esp\u00e8ces');
INSERT INTO MOYEN_PAIEMENT VALUES(3,0,'Virement');
INSERT INTO PIECE_IDENTITE VALUES(2,0,'C.I.N');
INSERT INTO PIECE_IDENTITE VALUES(3,0,'Permis');
INSERT INTO PIECE_IDENTITE VALUES(4,0,'Passport');
INSERT INTO PIECE_IDENTITE VALUES(5,0,'Registre de commerce');
INSERT INTO TYPE_ECRITURE VALUES(4,10,2,3,5,TRUE,'VERSEMENT PRIX',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(8,5,2,5,3,FALSE,'Frais mainlevee',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(9,1,1,2,5,TRUE,'Versement Frais',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(12,4,2,5,3,FALSE,'AVANCE PRIX',TRUE,3,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(13,1,2,5,3,FALSE,'Paiement TU/TE',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(14,2,2,5,3,FALSE,'PAIEMENT IR/PF',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(16,2,2,5,3,FALSE,'Dossier copropriete (reglement+plan)',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(17,1,2,5,3,FALSE,'Frais QUITUS',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(18,2,2,5,3,FALSE,'Creance syndicat',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(19,4,1,5,2,FALSE,'ENREGISTREMENT',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(20,1,1,5,2,FALSE,'Taxe sur les actes et conventions',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(21,7,1,5,2,FALSE,'TAXE FONCIERE',TRUE,3,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(22,2,1,5,2,FALSE,'Frais de dossier',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(23,6,1,5,2,FALSE,'TIMBRES ET EXPEDITIONS',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(24,5,1,5,2,FALSE,'Formalisation contrat pret',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(25,5,1,5,2,FALSE,'VACATIONS ET DEPLACEMENTS',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(26,5,1,2,2,FALSE,'HONORAIRES',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(27,1,1,5,2,FALSE,'TVA',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(28,1,1,5,2,FALSE,'Promesse',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(29,1,1,5,2,FALSE,'Annulation',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(30,1,1,1,1,FALSE,'Prorogation',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(31,1,1,5,2,FALSE,'Note agence urbaine',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(32,1,1,5,2,FALSE,'Correspondances et notifications',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(33,3,2,3,5,TRUE,'Avance Consignee',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(34,2,1,5,2,FALSE,'Demande certificat negatif',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(35,1,2,5,3,FALSE,'Honoraires expert',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(36,6,2,5,3,FALSE,'Honoraires geometre',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(37,1,2,5,3,FALSE,'Mise en concordandance(prix)',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(38,3,2,5,3,FALSE,'Paiement pret engagement',TRUE,3,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(39,1,2,5,3,FALSE,'Frais declaration fiscale',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(40,1,2,5,3,FALSE,'copies actes',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(41,1,1,5,2,FALSE,'Autres frais',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(42,1,2,5,3,FALSE,'Mainlevee droits complementaires enregistrement',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(43,1,1,5,2,FALSE,'Restitution FRAIS',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(44,1,2,5,3,FALSE,'Restitution PRIX',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(45,1,2,5,3,FALSE,'PROVISION',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(46,2,1,5,2,FALSE,'Demande certificat(FRAIS)',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(47,1,2,5,3,FALSE,'TTNB',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(52,1,3,5,2,FALSE,'FOURNISSEURS',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(54,0,3,1,5,FALSE,'SALAIRES',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(55,0,3,1,5,FALSE,'TELEPHONE.INTERNET...',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(56,0,3,1,5,FALSE,'REDAL',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(57,0,3,1,5,FALSE,'TIMBRES DE QUITTANCES',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(58,0,3,1,5,FALSE,'CNSS',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(59,0,3,1,5,FALSE,'AUTRE FRAIS',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(61,0,3,1,5,TRUE,'solde initial',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(62,0,3,NULL,NULL,TRUE,'annulation commission banques',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(63,0,3,NULL,NULL,TRUE,'autres recus',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(64,0,2,NULL,NULL,FALSE,'Mise \u00e0 jour titre foncier',TRUE,NULL,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(65,1,2,NULL,NULL,FALSE,'D\u00e9placement prix(compte source)',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(67,0,2,NULL,NULL,TRUE,'D\u00e9placement prix(compte d\u00e9stinataire)',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(68,0,2,NULL,NULL,FALSE,'Enregistrement acte vendeur',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(69,1,3,NULL,NULL,FALSE,'D\u00e9placement frais (compte source)',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(70,0,3,NULL,NULL,TRUE,'D\u00e9placement frais (compte destinataire)',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(71,1,2,NULL,NULL,FALSE,'Taxe Fonci\u00e8re(vendeur)',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(72,0,1,NULL,NULL,FALSE,'Deplacement frais (compte source)',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(73,0,1,NULL,NULL,TRUE,'Deplacement frais (compte destinataire)',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(74,0,3,NULL,NULL,FALSE,'TVA/C.A',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(75,0,3,NULL,NULL,FALSE,'IR(source)',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(76,0,3,NULL,NULL,FALSE,'Taxe Professionnelle',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(77,0,3,NULL,NULL,FALSE,'TH/TSC',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(78,0,1,NULL,NULL,FALSE,'Autres Imp\u00f4ts Etude',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(79,0,3,NULL,NULL,FALSE,'IR Etude',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(80,0,3,NULL,NULL,FALSE,'ASSURANCES',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(81,0,1,NULL,NULL,FALSE,'Publicit\u00e9 JAL & BO',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(82,0,1,NULL,NULL,FALSE,'TAXE JUDICIAIRE',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(84,0,3,NULL,NULL,FALSE,'COTISATIONS',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(85,0,3,NULL,NULL,FALSE,'Avance R\u00e9mun\u00e9ration Exploitant',TRUE,0,NULL,NULL,NULL);
INSERT INTO TYPE_ECRITURE VALUES(86,0,1,NULL,NULL,FALSE,'Droit Par Acte',TRUE,0,NULL,NULL,NULL);
INSERT INTO TRADUCTION VALUES(1,1,'PieceIdentite','Piece d''identit&eacute;','Piece d''identit&eacute;');
INSERT INTO TRADUCTION VALUES(2,1,'CategorieEcriture','Categorie d''&eacute;criture','Categorie d''&eacute;criture');
INSERT INTO TRADUCTION VALUES(3,1,'Civilite','Civilit&eacute;','Civilit&eacute;');
INSERT INTO TRADUCTION VALUES(4,1,'Client','Client','Client');
INSERT INTO TRADUCTION VALUES(5,0,'Compte','Compte',NULL);
INSERT INTO TRADUCTION VALUES(6,1,'JsecPermission','Permission','Permission');
INSERT INTO TRADUCTION VALUES(7,1,'JsecUserPermissionRel','Permission utilisateur','Permission utilisateur');
INSERT INTO TRADUCTION VALUES(8,2,'JsecRole','R\u00f4les','R&ocirc;les');
INSERT INTO TRADUCTION VALUES(9,1,'JsecUserRoleRel','R&ocirc;le utilisateur','R&ocirc;le utilisateur');
INSERT INTO TRADUCTION VALUES(10,1,'JsecRolePermissionRel','R&ocirc;le permission','R&ocirc;le permission');
INSERT INTO TRADUCTION VALUES(11,1,'Ecriture','Ecriture','Ecriture');
INSERT INTO TRADUCTION VALUES(12,1,'JsecUser','Utilisateur','Utilisateur');
INSERT INTO TRADUCTION VALUES(13,1,'EcritureDossier','Ecriture de Dossier','Ecriture de Dossier');
INSERT INTO TRADUCTION VALUES(14,1,'EtatEcriture','Etat d''ecriture','Etat d''ecriture');
INSERT INTO TRADUCTION VALUES(15,1,'Dossier','Dossier','Dossier');
INSERT INTO TRADUCTION VALUES(16,1,'MoyenPaiement','Moyen de Paiement','Moyen de Paiement');
INSERT INTO TRADUCTION VALUES(17,1,'TypeEcriture','Type d''&eacute;criture','Type d''&eacute;criture');
INSERT INTO TRADUCTION VALUES(18,1,'Acte','Acte','Acte');
INSERT INTO TRADUCTION VALUES(19,1,'Traduction','Traduction','Traduction');
INSERT INTO TRADUCTION VALUES(20,1,'Groupement','Groupement','Groupement');
INSERT INTO TRADUCTION VALUES(21,1,'CompteBancaire','Compte Bancaire','Compte Bancaire');
INSERT INTO TRADUCTION VALUES(22,1,'Param','Param&egrave;trage','Param&egrave;trage');
INSERT INTO TRADUCTION VALUES(23,1,'etude','\u00c9tude','Titre');
INSERT INTO TRADUCTION VALUES(24,1,'city','Sal\u00e9','Ville');
INSERT INTO TRADUCTION VALUES(25,0,'Activity','Journal d''activit&eacute;','Journal d''activit&eacute;');
INSERT INTO TRADUCTION VALUES(26,0,'Bien','Bien','Bien');
INSERT INTO TRADUCTION VALUES(27,0,'TypeDeBien','Type de Bien','Type de Bien');
INSERT INTO TRADUCTION VALUES(28,0,'Champ','Champ','Champ');
INSERT INTO TRADUCTION VALUES(29,0,'Valeur','Valeur','Valeur');
INSERT INTO TRADUCTION VALUES(30,0,'Operation','Op&eacute;ration','Op&eacute;ration');
INSERT INTO TRADUCTION VALUES(31,2,'id.enregistrement','21','ID Enregistrement');
INSERT INTO TRADUCTION VALUES(32,2,'id.taxe.fonciere','19','ID Taxe fonci&egrave;re');
INSERT INTO TRADUCTION VALUES(33,1,'id.pmt.pret.engagement','38','ID Paiement pr&ecirc;t engagement');
INSERT INTO TRADUCTION VALUES(34,0,'GmailAccount','raide.mailer','Compte Gmail');
INSERT INTO TRADUCTION VALUES(35,0,'GmailPass','raide2006','Mot de passe Gmail');
INSERT INTO TRADUCTION VALUES(36,1,'GmailStatusStarted','Serveur d\u00e9marr\u00e9','Statut de d&eacute;marrage');
INSERT INTO TRADUCTION VALUES(37,2,'GmailStatusStopped','Serveur arr\u00eat\u00e9','Statut d''arr&ecirc;t');
INSERT INTO TRADUCTION VALUES(38,1,'GmailStatusCmd','sudo -u houmam /home/houmam/status.sh','Commande de Statut');
INSERT INTO TRADUCTION VALUES(39,3,'dossiers.tag1','Non soumis &agrave; TF','Tag 1 des dossiers');
INSERT INTO TRADUCTION VALUES(40,0,'dossiers.tag2','Non soumis &agrave; IR/PF','Tag 2 des dossiers');
INSERT INTO TRADUCTION VALUES(41,0,'bien.libelle','Titre foncier','Titre foncier');
INSERT INTO TRADUCTION VALUES(42,0,'SoftwareUpdate','M.A.J Logicielle','M.A.J Logicielle');
INSERT INTO TRADUCTION VALUES(43,0,'dossier.tag3','Dossier archiv\u00e9','Cocher pour Dossier archiv\u00e9');
INSERT INTO TRADUCTION VALUES(44,0,'dossiers.tag3','Dossier archiv\u00e9','true');
INSERT INTO GROUPEMENT VALUES(1,0,'P.F.G.E');
INSERT INTO GROUPEMENT VALUES(2,1,'HON/TVA');
INSERT INTO GROUPEMENT VALUES(3,0,'C.A');
INSERT INTO GROUPEMENT VALUES(4,1,'Pr\u00e9l\u00e8vements prix');
INSERT INTO GROUPEMENT VALUES(5,0,'Frais divers');
INSERT INTO GROUPEMENT VALUES(6,0,'PROVISIONS');
INSERT INTO GROUPEMENT VALUES(7,0,'ENREGISTREMENT');
INSERT INTO GROUPEMENT VALUES(8,0,'TAXE FONCIERE');
INSERT INTO GROUPEMENT VALUES(10,0,'Avance prix');
INSERT INTO GROUPEMENT VALUES(11,0,'Instance frais');
INSERT INTO GROUPEMENT VALUES(12,0,'DEBITS PRIX');
INSERT INTO GROUPEMENT VALUES(14,0,'V.F');
INSERT INTO GROUPEMENT VALUES(15,0,'CHARGES');
INSERT INTO GROUPEMENT VALUES(17,0,'Autres Frais');
INSERT INTO GROUPEMENT VALUES(18,0,'VF');
INSERT INTO GROUPEMENT VALUES(19,0,'CERTIFICAT NEGATIF');
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(1,0,1,26);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(44,0,5,12);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(45,0,6,45);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(46,0,7,19);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(47,0,8,21);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(53,0,10,12);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(59,0,11,9);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(84,0,12,69);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(85,0,12,68);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(86,0,12,65);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(87,0,12,71);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(88,0,12,64);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(89,0,12,13);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(90,0,12,14);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(91,0,12,16);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(92,0,12,8);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(93,0,12,12);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(94,0,12,18);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(95,0,12,17);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(96,0,12,45);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(97,0,12,44);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(98,0,12,42);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(99,0,12,47);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(100,0,12,40);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(101,0,12,39);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(102,0,12,36);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(103,0,12,35);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(104,0,12,38);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(105,0,12,37);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(106,0,4,71);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(107,0,4,68);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(108,0,4,13);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(109,0,4,14);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(110,0,4,16);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(111,0,4,17);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(112,0,4,12);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(113,0,4,18);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(114,0,4,45);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(115,0,4,44);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(116,0,4,47);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(117,0,4,42);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(118,0,4,40);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(119,0,4,35);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(120,0,4,37);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(121,0,4,36);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(122,0,4,39);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(123,0,4,38);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(124,0,14,9);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(139,0,17,59);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(140,0,18,9);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(171,0,2,27);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(172,0,2,26);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(216,0,3,16);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(217,0,3,17);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(218,0,3,8);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(219,0,3,26);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(220,0,3,24);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(221,0,3,22);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(222,0,3,32);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(223,0,3,39);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(245,0,19,34);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(310,0,15,76);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(311,0,15,75);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(312,0,15,55);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(313,0,15,56);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(314,0,15,58);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(315,0,15,77);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(316,0,15,78);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(317,0,15,79);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(318,0,15,80);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(319,0,15,84);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(320,0,15,85);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(321,0,15,86);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(322,0,15,54);
INSERT INTO TYPE_ECRITURE_GROUPEMENT_REL VALUES(323,0,15,52);
INSERT INTO DATABASE_PATCH VALUES(1,0,'2008-08-28 12:27:10.886000000','arrondit le montant de *toutes* les ecritures \ufffd deux d\ufffdcimales',1,0,7,'round_montant_ecritures_2_decimales');
INSERT INTO DATABASE_PATCH VALUES(2,0,'2008-09-08 14:58:09.172000000','ajoute les permissions au niveau des clients et de leurs associations',1,0,8,'add_rbac_client_and_its_associations');
INSERT INTO DATABASE_PATCH VALUES(3,0,'2008-09-08 14:58:10.615000000','nettoie les colonnes non utilisees',1,0,8,'alter_dossier_table_and_other_stuff');
INSERT INTO DATABASE_PATCH VALUES(4,0,'2012-06-21 11:18:02.432000000','Drop Column Client.Prenom',5,0,11,'drop_client_prenom');
INSERT INTO SETTING VALUES(511,0,'02-application/actes','false','actes.creation.editeur',NULL,NULL,NULL,'boolean',NULL,'false',1,NULL);
INSERT INTO SETTING VALUES(512,0,'02-application/actes','false','actes.modification.editeur',NULL,NULL,NULL,'boolean',NULL,'false',2,NULL);
INSERT INTO SETTING VALUES(513,0,'02-application/actes','false','actes.creation.scanner',NULL,NULL,NULL,'boolean',NULL,'false',3,NULL);
INSERT INTO SETTING VALUES(514,0,'02-application/actes','false','actes.modification.scanner',NULL,NULL,NULL,'boolean',NULL,'false',4,NULL);
INSERT INTO SETTING VALUES(515,0,'02-application/actes','true','actes.modification.import.word',NULL,NULL,NULL,'boolean',NULL,'true',5,NULL);
INSERT INTO SETTING VALUES(516,1,'01-general','Etude 365','etude',NULL,NULL,NULL,'string',NULL,'Etude 365',6,NULL);
INSERT INTO SETTING VALUES(517,1,'02-application/ecritures','11','id.enregistrement',NULL,NULL,NULL,'string',NULL,'21',7,NULL);
INSERT INTO SETTING VALUES(518,1,'02-application/ecritures','12','id.taxe.fonciere',NULL,NULL,NULL,'string',NULL,'19',8,NULL);
INSERT INTO SETTING VALUES(519,1,'02-application/ecritures','13','id.pmt.pret.engagement',NULL,NULL,NULL,'string',NULL,'38',9,NULL);
INSERT INTO SETTING VALUES(520,1,'01-general','Rabat','city',NULL,NULL,NULL,'string',NULL,'Rabat',10,NULL);
INSERT INTO SETTING VALUES(521,1,'03-suivi/im','false','GmailBotEnable',NULL,NULL,NULL,'boolean',NULL,'true',11,NULL);
INSERT INTO SETTING VALUES(522,1,'03-suivi/im',NULL,'GmailAccount',NULL,NULL,NULL,'string',NULL,'mymail',12,NULL);
INSERT INTO SETTING VALUES(523,1,'03-suivi/im',NULL,'GmailPass',NULL,NULL,NULL,'string',NULL,'mypwd',13,NULL);
INSERT INTO SETTING VALUES(524,2,'03-suivi/im','Server Started','GmailStatusStarted',NULL,NULL,NULL,'string',NULL,'D\u00e9marr\u00e9',14,NULL);
INSERT INTO SETTING VALUES(525,2,'03-suivi/im','Server Stopped','GmailStatusStopped',NULL,NULL,NULL,'string',NULL,'Arr\u00eat en cours...',15,NULL);
INSERT INTO SETTING VALUES(526,1,'03-suivi/im',NULL,'GmailStatusCmd',NULL,NULL,NULL,'string',NULL,'',16,NULL);
INSERT INTO SETTING VALUES(527,0,'04-maintenance/sauvegarde','Accueil/travaux/Travaux ','share.backup.smbUrl',NULL,NULL,NULL,'string',NULL,'Accueil/travaux/Travaux ',17,NULL);
INSERT INTO SETTING VALUES(528,11,'01-general','true','system.dst',NULL,NULL,NULL,'boolean',NULL,'false',7,NULL);
INSERT INTO SETTING VALUES(529,356,'02-application/ecritures','false','ecriture.verrouiller.validees',NULL,NULL,NULL,'boolean',NULL,'false',11,NULL);
INSERT INTO SETTING VALUES(530,2,'03-suivi/im','false','gmail.BotEnable',NULL,NULL,NULL,'boolean',NULL,'false',13,NULL);
INSERT INTO SETTING VALUES(531,2,'03-suivi/im','false','gmail.follow.server.url',NULL,NULL,NULL,'boolean',NULL,'false',14,NULL);
INSERT INTO SETTING VALUES(532,1,'03-suivi/im',NULL,'gmail.Account',NULL,NULL,NULL,'string',NULL,'mymail',15,NULL);
INSERT INTO SETTING VALUES(533,1,'03-suivi/im',NULL,'gmail.Pass',NULL,NULL,NULL,'string',NULL,'mypwd',16,NULL);
INSERT INTO SETTING VALUES(534,2,'03-suivi/im','Server Started','gmail.StatusStarted',NULL,NULL,NULL,'string',NULL,'Serveur demarr\u00e9',17,NULL);
INSERT INTO SETTING VALUES(535,1,'03-suivi/im','Server Stopped','gmail.StatusStopped',NULL,NULL,NULL,'string',NULL,'Arr\u00eat en cours',18,NULL);
INSERT INTO SETTING VALUES(536,0,'03-suivi/im',NULL,'gmail.StatusCmd',NULL,NULL,NULL,'string',NULL,NULL,19,NULL);
INSERT INTO SETTING VALUES(537,5,'04-maintenance/taches',NULL,'SendBackupJob.to',NULL,NULL,NULL,'string',NULL,'',20,NULL);
INSERT INTO SETTING VALUES(538,23,'04-maintenance/taches','Accueil/travaux/Travaux ','FileBackupJob.smbUrl',NULL,NULL,NULL,'string',NULL,'',21,NULL);
INSERT INTO SETTING VALUES(539,1786,'04-maintenance/taches','false','FileBackupJob.enabled',NULL,NULL,NULL,'boolean',NULL,'false',22,NULL);
INSERT INTO SETTING VALUES(540,10,'04-maintenance/taches','0 0 10 ? * *','FileBackupJob.cron',NULL,NULL,NULL,'string',NULL,'0 30 13 ? * *',23,NULL);
INSERT INTO SETTING VALUES(541,2256,'04-maintenance/taches','true','DbBackupJob.enabled',NULL,NULL,NULL,'boolean',NULL,'true',24,NULL);
INSERT INTO SETTING VALUES(542,12,'04-maintenance/taches','0 0 11 ? * *','DbBackupJob.cron',NULL,NULL,NULL,'string',NULL,'0 45 19 ? * *',25,NULL);
INSERT INTO SETTING VALUES(543,0,'04-maintenance/taches','false','CleanUpJob.enabled',NULL,NULL,NULL,'boolean',NULL,'false',26,NULL);
INSERT INTO SETTING VALUES(544,1,'04-maintenance/taches','0 00 16 ? * 6','CleanUpJob.cron',NULL,NULL,NULL,'string',NULL,'0 0 16 ? * 6',27,NULL);
INSERT INTO SETTING VALUES(545,2252,'04-maintenance/taches','true','SendBackupJob.enabled',NULL,NULL,NULL,'boolean',NULL,'true',28,NULL);
INSERT INTO SETTING VALUES(546,15,'04-maintenance/taches','0 30 16 ? * 6','SendBackupJob.cron',NULL,NULL,NULL,'string',NULL,'0 30 20 ? * *',29,NULL);
INSERT INTO SETTING VALUES(547,7,'04-maintenance/SendFileBackupJob',NULL,'SendFileBackupJob.to',NULL,NULL,NULL,'string',NULL,'',21,NULL);
INSERT INTO SETTING VALUES(548,1,'04-maintenance/FileBackupJob',NULL,'FileBackupJob.username',NULL,NULL,NULL,'string',NULL,'',23,NULL);
INSERT INTO SETTING VALUES(549,1,'04-maintenance/FileBackupJob',NULL,'FileBackupJob.password',NULL,NULL,NULL,'string',NULL,'',24,NULL);
INSERT INTO SETTING VALUES(550,1,'04-maintenance/FileBackupJob',NULL,'FileBackupJob.domain',NULL,NULL,NULL,'string',NULL,'',25,NULL);
INSERT INTO SETTING VALUES(551,1779,'04-maintenance/SendFileBackupJob','true','SendFileBackupJob.enabled',NULL,NULL,NULL,'boolean',NULL,'false',30,NULL);
INSERT INTO SETTING VALUES(552,11,'04-maintenance/SendFileBackupJob','0 0 12 ? * *','SendFileBackupJob.cron',NULL,NULL,NULL,'string',NULL,'0 0 20 ? * *',31,NULL);
INSERT INTO SETTING VALUES(553,5,'04-maintenance/FileBackupJob','Accueil\backup','FileBackupJob.backup.smbUrl',NULL,NULL,NULL,'string',NULL,'',23,NULL);
INSERT INTO SETTING VALUES(554,5,'04-maintenance/FileBackupJob','Cp864','FileBackupJob.encoding',NULL,NULL,NULL,'string',NULL,'Cp864',27,NULL);
INSERT INTO SETTING VALUES(555,1,'04-maintenance/FileBackupJob','true','FileBackupJob.warn.missing',NULL,NULL,NULL,'boolean',NULL,'false',28,NULL);
INSERT INTO SETTING VALUES(594,1,'01-general/affichage','classic','ui.theme',NULL,NULL,NULL,'string',NULL,'classic',13,NULL);
INSERT INTO SETTING VALUES(595,5,'01-general/affichage','false','ui.theme.per.user',NULL,NULL,NULL,'boolean',NULL,'true',14,NULL);
INSERT INTO SETTING VALUES(596,0,'04-maintenance/DbFlusherJob','false','DbFlusherJob.enabled',NULL,NULL,NULL,'boolean',NULL,'false',31,NULL);
INSERT INTO SETTING VALUES(647,10,'02-application/ecritures','4','ecriture.verrouiller.validees.delai',NULL,NULL,NULL,'integer',NULL,'8',12,NULL);
INSERT INTO SETTING VALUES(768,0,'02-application/ecritures','true','ecriture.verrouiller.validees.demarrage',NULL,NULL,NULL,'boolean',NULL,'true',12,NULL);
INSERT INTO SETTING VALUES(769,5,'04-maintenance/SoftwareUpdateJob','true','SoftwareUpdateJob.enabled',NULL,NULL,NULL,'boolean',NULL,'false',36,NULL);
INSERT INTO SETTING VALUES(770,0,'04-maintenance/SoftwareUpdateJob','0 0 11 ? * *','SoftwareUpdateJob.cron',NULL,NULL,NULL,'string',NULL,'0 0 11 ? * *',37,NULL);
INSERT INTO SETTING VALUES(771,290,'04-maintenance/SoftwareUpdateInstallJob','false','SoftwareUpdateInstallJob.enabled',NULL,NULL,NULL,'boolean',NULL,'false',34,NULL);
INSERT INTO SETTING VALUES(772,413,'04-maintenance/SoftwareUpdateDownloadJob','false','SoftwareUpdateDownloadJob.enabled',NULL,NULL,NULL,'boolean',NULL,'true',35,NULL);
INSERT INTO SETTING VALUES(773,9,'04-maintenance/SoftwareUpdateDownloadJob','0 0 10 ? * *','SoftwareUpdateDownloadJob.cron',NULL,NULL,NULL,'string',NULL,'0 0 21 ? * *',37,NULL);
INSERT INTO SETTING VALUES(774,7,'04-maintenance/SoftwareUpdateInstallJob','0 0 12 ? * *','SoftwareUpdateInstallJob.cron',NULL,NULL,NULL,'string',NULL,'0 15 21 ? * 6',41,NULL);
INSERT INTO SETTING VALUES(853,1,'01-general/avance','https://dl.dropboxusercontent.com/u/13297917/latest.xml','system.update.url',NULL,NULL,NULL,'string',NULL,'',24,NULL);
INSERT INTO CHAMP VALUES(1,0,NULL,NULL,NULL,'Nombre de pieces','integer',NULL,NULL);
INSERT INTO CHAMP VALUES(2,0,NULL,NULL,NULL,'Numero','integer',NULL,NULL);
INSERT INTO CHAMP VALUES(3,0,NULL,NULL,NULL,'Montant','amount',NULL,NULL);
INSERT INTO CHAMP VALUES(4,0,NULL,NULL,NULL,'Etage','integer',NULL,NULL);
INSERT INTO CHAMP VALUES(5,0,NULL,NULL,NULL,'Places de Garage','integer',NULL,NULL);
INSERT INTO CHAMP VALUES(6,0,NULL,NULL,NULL,'Superficie','integer',NULL,NULL);
INSERT INTO TYPE_DE_BIEN VALUES(1,0,'Appartement');
INSERT INTO TYPE_DE_BIEN VALUES(2,0,'Parcelle de terrain');
INSERT INTO TYPE_DE_BIEN_CHAMP VALUES(1,1);
INSERT INTO TYPE_DE_BIEN_CHAMP VALUES(2,1);
INSERT INTO TYPE_DE_BIEN_CHAMP VALUES(3,1);
INSERT INTO TYPE_DE_BIEN_CHAMP VALUES(4,1);
INSERT INTO TYPE_DE_BIEN_CHAMP VALUES(5,1);
INSERT INTO TYPE_DE_BIEN_CHAMP VALUES(6,1);
INSERT INTO TYPE_DE_BIEN_CHAMP VALUES(2,2);
INSERT INTO TYPE_DE_BIEN_CHAMP VALUES(3,2);
INSERT INTO TYPE_DE_BIEN_CHAMP VALUES(6,2);
INSERT INTO TAGS VALUES(1,0,'Dossier','dossiers.tag1');
INSERT INTO TAGS VALUES(2,0,'Dossier','dossiers.tag2');
