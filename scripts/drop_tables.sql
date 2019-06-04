drop table cliente cascade;
drop table emprestimo cascade;
drop table funcionario cascade;
drop table livro cascade;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.13
-- Dumped by pg_dump version 9.6.13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: projeto
--

CREATE TABLE public.cliente (
    id bigint NOT NULL,
    nome character varying NOT NULL,
    rg character varying NOT NULL,
    cpf character varying NOT NULL,
    endereco character varying NOT NULL,
    telefone character varying NOT NULL
);


ALTER TABLE public.cliente OWNER TO projeto;

--
-- Name: cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: projeto
--

CREATE SEQUENCE public.cliente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cliente_id_seq OWNER TO projeto;

--
-- Name: cliente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: projeto
--

ALTER SEQUENCE public.cliente_id_seq OWNED BY public.cliente.id;


--
-- Name: emprestimo; Type: TABLE; Schema: public; Owner: projeto
--

CREATE TABLE public.emprestimo (
    id bigint NOT NULL,
    cliid bigint NOT NULL,
    livid bigint NOT NULL,
    data_emp date NOT NULL,
    data_dev date NOT NULL
);


ALTER TABLE public.emprestimo OWNER TO projeto;

--
-- Name: emprestimo_id_seq; Type: SEQUENCE; Schema: public; Owner: projeto
--

CREATE SEQUENCE public.emprestimo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.emprestimo_id_seq OWNER TO projeto;

--
-- Name: emprestimo_id_seq1; Type: SEQUENCE; Schema: public; Owner: projeto
--

CREATE SEQUENCE public.emprestimo_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.emprestimo_id_seq1 OWNER TO projeto;

--
-- Name: emprestimo_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: projeto
--

ALTER SEQUENCE public.emprestimo_id_seq1 OWNED BY public.emprestimo.id;


--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: projeto
--

CREATE TABLE public.funcionario (
    id bigint NOT NULL,
    email character varying NOT NULL,
    senha character varying NOT NULL
);


ALTER TABLE public.funcionario OWNER TO projeto;

--
-- Name: funcionario_id_seq; Type: SEQUENCE; Schema: public; Owner: projeto
--

CREATE SEQUENCE public.funcionario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.funcionario_id_seq OWNER TO projeto;

--
-- Name: funcionario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: projeto
--

ALTER SEQUENCE public.funcionario_id_seq OWNED BY public.funcionario.id;


--
-- Name: livro; Type: TABLE; Schema: public; Owner: projeto
--

CREATE TABLE public.livro (
    id bigint NOT NULL,
    titulo character varying NOT NULL,
    autor character varying NOT NULL,
    publicacao character varying NOT NULL,
    descricao character varying NOT NULL,
    assunto character varying NOT NULL
);


ALTER TABLE public.livro OWNER TO projeto;

--
-- Name: livro_id_seq; Type: SEQUENCE; Schema: public; Owner: projeto
--

CREATE SEQUENCE public.livro_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.livro_id_seq OWNER TO projeto;

--
-- Name: livro_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: projeto
--

ALTER SEQUENCE public.livro_id_seq OWNED BY public.livro.id;


--
-- Name: cliente id; Type: DEFAULT; Schema: public; Owner: projeto
--

ALTER TABLE ONLY public.cliente ALTER COLUMN id SET DEFAULT nextval('public.cliente_id_seq'::regclass);


--
-- Name: emprestimo id; Type: DEFAULT; Schema: public; Owner: projeto
--

ALTER TABLE ONLY public.emprestimo ALTER COLUMN id SET DEFAULT nextval('public.emprestimo_id_seq1'::regclass);


--
-- Name: funcionario id; Type: DEFAULT; Schema: public; Owner: projeto
--

ALTER TABLE ONLY public.funcionario ALTER COLUMN id SET DEFAULT nextval('public.funcionario_id_seq'::regclass);


--
-- Name: livro id; Type: DEFAULT; Schema: public; Owner: projeto
--

ALTER TABLE ONLY public.livro ALTER COLUMN id SET DEFAULT nextval('public.livro_id_seq'::regclass);


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: projeto
--

COPY public.cliente (id, nome, rg, cpf, endereco, telefone) FROM stdin;
\.


--
-- Name: cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: projeto
--

SELECT pg_catalog.setval('public.cliente_id_seq', 1, false);


--
-- Data for Name: emprestimo; Type: TABLE DATA; Schema: public; Owner: projeto
--

COPY public.emprestimo (id, cliid, livid, data_emp, data_dev) FROM stdin;
\.


--
-- Name: emprestimo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: projeto
--

SELECT pg_catalog.setval('public.emprestimo_id_seq', 1, false);


--
-- Name: emprestimo_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: projeto
--

SELECT pg_catalog.setval('public.emprestimo_id_seq1', 1, false);


--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: projeto
--

COPY public.funcionario (id, email, senha) FROM stdin;
\.


--
-- Name: funcionario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: projeto
--

SELECT pg_catalog.setval('public.funcionario_id_seq', 1, false);


--
-- Data for Name: livro; Type: TABLE DATA; Schema: public; Owner: projeto
--

COPY public.livro (id, titulo, autor, publicacao, descricao, assunto) FROM stdin;
\.


--
-- Name: livro_id_seq; Type: SEQUENCE SET; Schema: public; Owner: projeto
--

SELECT pg_catalog.setval('public.livro_id_seq', 1, false);


--
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: projeto
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id);


--
-- Name: emprestimo emprestimo_pkey; Type: CONSTRAINT; Schema: public; Owner: projeto
--

ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT emprestimo_pkey PRIMARY KEY (id);


--
-- Name: funcionario funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: projeto
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (id);


--
-- Name: livro livro_pkey; Type: CONSTRAINT; Schema: public; Owner: projeto
--

ALTER TABLE ONLY public.livro
    ADD CONSTRAINT livro_pkey PRIMARY KEY (id);


--
-- Name: funcionario unique_rest_email; Type: CONSTRAINT; Schema: public; Owner: projeto
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT unique_rest_email UNIQUE (email);


--
-- Name: emprestimo emprestimo_cliid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: projeto
--

ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT emprestimo_cliid_fkey FOREIGN KEY (cliid) REFERENCES public.cliente(id);


--
-- Name: emprestimo emprestimo_livid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: projeto
--

ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT emprestimo_livid_fkey FOREIGN KEY (livid) REFERENCES public.livro(id);


--
-- PostgreSQL database dump complete
--

