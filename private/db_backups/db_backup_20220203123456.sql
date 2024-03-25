PGDMP         8                |            mcabs_tracker_development    13.7 (Debian 13.7-0+deb11u1)    13.7 (Debian 13.7-0+deb11u1) i    C           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            D           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            E           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            F           1262    16385    mcabs_tracker_development    DATABASE     j   CREATE DATABASE mcabs_tracker_development WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'C.UTF-8';
 )   DROP DATABASE mcabs_tracker_development;
                test_app    false            �            1255    16516    update_attendance_points()    FUNCTION     :  CREATE FUNCTION public.update_attendance_points() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF NEW."eventPoints" IS DISTINCT FROM OLD."eventPoints" THEN
      UPDATE attendances
      SET "pointsAwarded" = NEW."eventPoints"
      WHERE "eventID" = NEW.id;
    END IF;
    RETURN NEW;
  END;
  $$;
 1   DROP FUNCTION public.update_attendance_points();
       public          test_app    false            �            1255    16514 &   update_user_points_from_event_change()    FUNCTION     !  CREATE FUNCTION public.update_user_points_from_event_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
      UPDATE users
      SET total_points = (
        SELECT SUM("numPointsAwarded")
        FROM points
        WHERE "awardedTo" = users."uid"
      ) + (
        SELECT SUM("pointsAwarded")
        FROM attendances
        WHERE "googleUserID" = users."uid"
      )
      WHERE "uid" IN (
        SELECT "googleUserID"
        FROM attendances
        WHERE "eventID" = NEW."id"
      );
      RETURN NEW;
    END;
    $$;
 =   DROP FUNCTION public.update_user_points_from_event_change();
       public          test_app    false            �            1255    16509    update_user_total_points()    FUNCTION     �  CREATE FUNCTION public.update_user_total_points() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      BEGIN
        UPDATE users
        SET total_points = (
          SELECT SUM("numPointsAwarded")
          FROM points
          WHERE "awardedTo" = NEW."awardedTo"
        ) + (
          SELECT COALESCE(SUM("pointsAwarded"), 0)
          FROM attendances
          WHERE "googleUserID" = NEW."awardedTo"
        )
        WHERE "uid" = NEW."awardedTo";
        RETURN NEW;
      END;
      $$;
 1   DROP FUNCTION public.update_user_total_points();
       public          test_app    false            �            1255    16512 *   update_user_total_points_from_attendance()    FUNCTION     �  CREATE FUNCTION public.update_user_total_points_from_attendance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
      UPDATE users
      SET total_points = (
        SELECT SUM("numPointsAwarded")
        FROM points
        WHERE "awardedTo" = NEW."googleUserID"
      ) + (
        SELECT SUM("pointsAwarded")
        FROM attendances
        WHERE "googleUserID" = NEW."googleUserID"
      )
      WHERE "uid" = NEW."googleUserID";
      RETURN NEW;
    END;
    $$;
 A   DROP FUNCTION public.update_user_total_points_from_attendance();
       public          test_app    false            �            1259    16567    action_text_rich_texts    TABLE     6  CREATE TABLE public.action_text_rich_texts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    body text,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 *   DROP TABLE public.action_text_rich_texts;
       public         heap    test_app    false            �            1259    16565    action_text_rich_texts_id_seq    SEQUENCE     �   CREATE SEQUENCE public.action_text_rich_texts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.action_text_rich_texts_id_seq;
       public          test_app    false    221            G           0    0    action_text_rich_texts_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.action_text_rich_texts_id_seq OWNED BY public.action_text_rich_texts.id;
          public          test_app    false    220            �            1259    16532    active_storage_attachments    TABLE       CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);
 .   DROP TABLE public.active_storage_attachments;
       public         heap    test_app    false            �            1259    16530 !   active_storage_attachments_id_seq    SEQUENCE     �   CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.active_storage_attachments_id_seq;
       public          test_app    false    217            H           0    0 !   active_storage_attachments_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;
          public          test_app    false    216            �            1259    16520    active_storage_blobs    TABLE     m  CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);
 (   DROP TABLE public.active_storage_blobs;
       public         heap    test_app    false            �            1259    16518    active_storage_blobs_id_seq    SEQUENCE     �   CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.active_storage_blobs_id_seq;
       public          test_app    false    215            I           0    0    active_storage_blobs_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;
          public          test_app    false    214            �            1259    16550    active_storage_variant_records    TABLE     �   CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);
 2   DROP TABLE public.active_storage_variant_records;
       public         heap    test_app    false            �            1259    16548 %   active_storage_variant_records_id_seq    SEQUENCE     �   CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public.active_storage_variant_records_id_seq;
       public          test_app    false    219            J           0    0 %   active_storage_variant_records_id_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;
          public          test_app    false    218            �            1259    16415    announcements    TABLE     <  CREATE TABLE public.announcements (
    "googleUserID" character varying,
    subject text,
    "dateOfAnnouncement" timestamp(6) without time zone,
    body text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    "announcementID" bigint NOT NULL
);
 !   DROP TABLE public.announcements;
       public         heap    test_app    false            �            1259    16424     announcements_announcementID_seq    SEQUENCE     �   CREATE SEQUENCE public."announcements_announcementID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public."announcements_announcementID_seq";
       public          test_app    false    204            K           0    0     announcements_announcementID_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public."announcements_announcementID_seq" OWNED BY public.announcements."announcementID";
          public          test_app    false    205            �            1259    16394    ar_internal_metadata    TABLE     �   CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 (   DROP TABLE public.ar_internal_metadata;
       public         heap    test_app    false            �            1259    16490    attendances    TABLE     -  CREATE TABLE public.attendances (
    id bigint NOT NULL,
    "eventID" integer,
    "googleUserID" text,
    "timeOfCheckIn" timestamp(6) without time zone,
    "pointsAwarded" integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
    DROP TABLE public.attendances;
       public         heap    test_app    false            �            1259    16488    attendances_id_seq    SEQUENCE     {   CREATE SEQUENCE public.attendances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.attendances_id_seq;
       public          test_app    false    213            L           0    0    attendances_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.attendances_id_seq OWNED BY public.attendances.id;
          public          test_app    false    212            �            1259    16404    events    TABLE     �  CREATE TABLE public.events (
    id bigint NOT NULL,
    "eventLocation" text,
    "eventInfo" text,
    "eventName" character varying,
    "eventTime" timestamp(6) without time zone,
    "eventPoints" integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    sponsor_title character varying,
    sponsor_description text,
    password character varying
);
    DROP TABLE public.events;
       public         heap    test_app    false            �            1259    16402    events_id_seq    SEQUENCE     v   CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.events_id_seq;
       public          test_app    false    203            M           0    0    events_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;
          public          test_app    false    202            �            1259    16457    points    TABLE     \  CREATE TABLE public.points (
    id bigint NOT NULL,
    "numPointsAwarded" integer,
    "awardedBy" character varying,
    "awardedTo" character varying,
    "dateOfAward" timestamp(6) without time zone,
    "awardDescription" text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
    DROP TABLE public.points;
       public         heap    test_app    false            �            1259    16455    points_id_seq    SEQUENCE     v   CREATE SEQUENCE public.points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.points_id_seq;
       public          test_app    false    209            N           0    0    points_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.points_id_seq OWNED BY public.points.id;
          public          test_app    false    208            �            1259    16468    rsvps    TABLE     �   CREATE TABLE public.rsvps (
    id bigint NOT NULL,
    user_uid character varying,
    event_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
    DROP TABLE public.rsvps;
       public         heap    test_app    false            �            1259    16466    rsvps_id_seq    SEQUENCE     u   CREATE SEQUENCE public.rsvps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.rsvps_id_seq;
       public          test_app    false    211            O           0    0    rsvps_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.rsvps_id_seq OWNED BY public.rsvps.id;
          public          test_app    false    210            �            1259    16386    schema_migrations    TABLE     R   CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);
 %   DROP TABLE public.schema_migrations;
       public         heap    test_app    false            �            1259    16438    users    TABLE     �  CREATE TABLE public.users (
    id bigint NOT NULL,
    uid character varying,
    email character varying NOT NULL,
    is_admin boolean DEFAULT false,
    full_name character varying,
    middle_initial character varying(1),
    gender character varying,
    is_hispanic_or_latino boolean,
    race character varying,
    is_us_citizen boolean,
    is_first_generation_college_student boolean,
    date_of_birth timestamp(6) without time zone,
    phone_number character varying,
    avatar_url character varying,
    bio text,
    classification character varying,
    total_points integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    role integer
);
    DROP TABLE public.users;
       public         heap    test_app    false            �            1259    16436    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          test_app    false    207            P           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          test_app    false    206            {           2604    16570    action_text_rich_texts id    DEFAULT     �   ALTER TABLE ONLY public.action_text_rich_texts ALTER COLUMN id SET DEFAULT nextval('public.action_text_rich_texts_id_seq'::regclass);
 H   ALTER TABLE public.action_text_rich_texts ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    220    221    221            y           2604    16535    active_storage_attachments id    DEFAULT     �   ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);
 L   ALTER TABLE public.active_storage_attachments ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    216    217    217            x           2604    16523    active_storage_blobs id    DEFAULT     �   ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);
 F   ALTER TABLE public.active_storage_blobs ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    215    214    215            z           2604    16553 !   active_storage_variant_records id    DEFAULT     �   ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);
 P   ALTER TABLE public.active_storage_variant_records ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    219    218    219            r           2604    16426    announcements announcementID    DEFAULT     �   ALTER TABLE ONLY public.announcements ALTER COLUMN "announcementID" SET DEFAULT nextval('public."announcements_announcementID_seq"'::regclass);
 M   ALTER TABLE public.announcements ALTER COLUMN "announcementID" DROP DEFAULT;
       public          test_app    false    205    204            w           2604    16493    attendances id    DEFAULT     p   ALTER TABLE ONLY public.attendances ALTER COLUMN id SET DEFAULT nextval('public.attendances_id_seq'::regclass);
 =   ALTER TABLE public.attendances ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    213    212    213            q           2604    16407 	   events id    DEFAULT     f   ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);
 8   ALTER TABLE public.events ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    202    203    203            u           2604    16460 	   points id    DEFAULT     f   ALTER TABLE ONLY public.points ALTER COLUMN id SET DEFAULT nextval('public.points_id_seq'::regclass);
 8   ALTER TABLE public.points ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    209    208    209            v           2604    16471    rsvps id    DEFAULT     d   ALTER TABLE ONLY public.rsvps ALTER COLUMN id SET DEFAULT nextval('public.rsvps_id_seq'::regclass);
 7   ALTER TABLE public.rsvps ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    210    211    211            s           2604    16441    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    206    207    207            @          0    16567    action_text_rich_texts 
   TABLE DATA           p   COPY public.action_text_rich_texts (id, name, body, record_type, record_id, created_at, updated_at) FROM stdin;
    public          test_app    false    221   O�       <          0    16532    active_storage_attachments 
   TABLE DATA           k   COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
    public          test_app    false    217   l�       :          0    16520    active_storage_blobs 
   TABLE DATA           �   COPY public.active_storage_blobs (id, key, filename, content_type, metadata, service_name, byte_size, checksum, created_at) FROM stdin;
    public          test_app    false    215   ��       >          0    16550    active_storage_variant_records 
   TABLE DATA           W   COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
    public          test_app    false    219   ��       /          0    16415    announcements 
   TABLE DATA           �   COPY public.announcements ("googleUserID", subject, "dateOfAnnouncement", body, created_at, updated_at, "announcementID") FROM stdin;
    public          test_app    false    204   Î       ,          0    16394    ar_internal_metadata 
   TABLE DATA           R   COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
    public          test_app    false    201   ��       8          0    16490    attendances 
   TABLE DATA           ~   COPY public.attendances (id, "eventID", "googleUserID", "timeOfCheckIn", "pointsAwarded", created_at, updated_at) FROM stdin;
    public          test_app    false    213   /�       .          0    16404    events 
   TABLE DATA           �   COPY public.events (id, "eventLocation", "eventInfo", "eventName", "eventTime", "eventPoints", created_at, updated_at, sponsor_title, sponsor_description, password) FROM stdin;
    public          test_app    false    203   L�       4          0    16457    points 
   TABLE DATA           �   COPY public.points (id, "numPointsAwarded", "awardedBy", "awardedTo", "dateOfAward", "awardDescription", created_at, updated_at) FROM stdin;
    public          test_app    false    209   i�       6          0    16468    rsvps 
   TABLE DATA           O   COPY public.rsvps (id, user_uid, event_id, created_at, updated_at) FROM stdin;
    public          test_app    false    211   ��       +          0    16386    schema_migrations 
   TABLE DATA           4   COPY public.schema_migrations (version) FROM stdin;
    public          test_app    false    200   ��       2          0    16438    users 
   TABLE DATA             COPY public.users (id, uid, email, is_admin, full_name, middle_initial, gender, is_hispanic_or_latino, race, is_us_citizen, is_first_generation_college_student, date_of_birth, phone_number, avatar_url, bio, classification, total_points, created_at, updated_at, role) FROM stdin;
    public          test_app    false    207   =�       Q           0    0    action_text_rich_texts_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.action_text_rich_texts_id_seq', 58, true);
          public          test_app    false    220            R           0    0 !   active_storage_attachments_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 1, false);
          public          test_app    false    216            S           0    0    active_storage_blobs_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 1, false);
          public          test_app    false    214            T           0    0 %   active_storage_variant_records_id_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 1, false);
          public          test_app    false    218            U           0    0     announcements_announcementID_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."announcements_announcementID_seq"', 70, true);
          public          test_app    false    205            V           0    0    attendances_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.attendances_id_seq', 85, true);
          public          test_app    false    212            W           0    0    events_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.events_id_seq', 276, true);
          public          test_app    false    202            X           0    0    points_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.points_id_seq', 66, true);
          public          test_app    false    208            Y           0    0    rsvps_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.rsvps_id_seq', 28, true);
          public          test_app    false    210            Z           0    0    users_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.users_id_seq', 931, true);
          public          test_app    false    206            �           2606    16575 2   action_text_rich_texts action_text_rich_texts_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.action_text_rich_texts
    ADD CONSTRAINT action_text_rich_texts_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.action_text_rich_texts DROP CONSTRAINT action_text_rich_texts_pkey;
       public            test_app    false    221            �           2606    16540 :   active_storage_attachments active_storage_attachments_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.active_storage_attachments DROP CONSTRAINT active_storage_attachments_pkey;
       public            test_app    false    217            �           2606    16528 .   active_storage_blobs active_storage_blobs_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.active_storage_blobs DROP CONSTRAINT active_storage_blobs_pkey;
       public            test_app    false    215            �           2606    16558 B   active_storage_variant_records active_storage_variant_records_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);
 l   ALTER TABLE ONLY public.active_storage_variant_records DROP CONSTRAINT active_storage_variant_records_pkey;
       public            test_app    false    219            �           2606    16428     announcements announcements_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY ("announcementID");
 J   ALTER TABLE ONLY public.announcements DROP CONSTRAINT announcements_pkey;
       public            test_app    false    204                       2606    16401 .   ar_internal_metadata ar_internal_metadata_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);
 X   ALTER TABLE ONLY public.ar_internal_metadata DROP CONSTRAINT ar_internal_metadata_pkey;
       public            test_app    false    201            �           2606    16498    attendances attendances_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.attendances DROP CONSTRAINT attendances_pkey;
       public            test_app    false    213            �           2606    16412    events events_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.events DROP CONSTRAINT events_pkey;
       public            test_app    false    203            �           2606    16465    points points_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.points
    ADD CONSTRAINT points_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.points DROP CONSTRAINT points_pkey;
       public            test_app    false    209            �           2606    16476    rsvps rsvps_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.rsvps
    ADD CONSTRAINT rsvps_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.rsvps DROP CONSTRAINT rsvps_pkey;
       public            test_app    false    211            }           2606    16393 (   schema_migrations schema_migrations_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
 R   ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
       public            test_app    false    200            �           2606    16447    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            test_app    false    207            �           1259    16576 '   index_action_text_rich_texts_uniqueness    INDEX     �   CREATE UNIQUE INDEX index_action_text_rich_texts_uniqueness ON public.action_text_rich_texts USING btree (record_type, record_id, name);
 ;   DROP INDEX public.index_action_text_rich_texts_uniqueness;
       public            test_app    false    221    221    221            �           1259    16546 +   index_active_storage_attachments_on_blob_id    INDEX     u   CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);
 ?   DROP INDEX public.index_active_storage_attachments_on_blob_id;
       public            test_app    false    217            �           1259    16547 +   index_active_storage_attachments_uniqueness    INDEX     �   CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);
 ?   DROP INDEX public.index_active_storage_attachments_uniqueness;
       public            test_app    false    217    217    217    217            �           1259    16529 !   index_active_storage_blobs_on_key    INDEX     h   CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);
 5   DROP INDEX public.index_active_storage_blobs_on_key;
       public            test_app    false    215            �           1259    16564 /   index_active_storage_variant_records_uniqueness    INDEX     �   CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);
 C   DROP INDEX public.index_active_storage_variant_records_uniqueness;
       public            test_app    false    219    219            �           1259    16482    index_rsvps_on_event_id    INDEX     M   CREATE INDEX index_rsvps_on_event_id ON public.rsvps USING btree (event_id);
 +   DROP INDEX public.index_rsvps_on_event_id;
       public            test_app    false    211            �           1259    16448    index_users_on_email    INDEX     N   CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);
 (   DROP INDEX public.index_users_on_email;
       public            test_app    false    207            �           1259    16449    index_users_on_uid    INDEX     J   CREATE UNIQUE INDEX index_users_on_uid ON public.users USING btree (uid);
 &   DROP INDEX public.index_users_on_uid;
       public            test_app    false    207            �           2620    16517 2   events update_attendance_points_after_event_update    TRIGGER     �   CREATE TRIGGER update_attendance_points_after_event_update AFTER UPDATE OF "eventPoints" ON public.events FOR EACH ROW EXECUTE FUNCTION public.update_attendance_points();
 K   DROP TRIGGER update_attendance_points_after_event_update ON public.events;
       public          test_app    false    203    203    224            �           2620    16513 *   attendances update_points_after_attendance    TRIGGER     �   CREATE TRIGGER update_points_after_attendance AFTER INSERT ON public.attendances FOR EACH ROW EXECUTE FUNCTION public.update_user_total_points_from_attendance();
 C   DROP TRIGGER update_points_after_attendance ON public.attendances;
       public          test_app    false    213    222            �           2620    16511 !   points update_points_after_delete    TRIGGER     �   CREATE TRIGGER update_points_after_delete AFTER DELETE ON public.points FOR EACH ROW EXECUTE FUNCTION public.update_user_total_points();
 :   DROP TRIGGER update_points_after_delete ON public.points;
       public          test_app    false    225    209            �           2620    16515 '   events update_points_after_event_update    TRIGGER     �   CREATE TRIGGER update_points_after_event_update AFTER UPDATE ON public.events FOR EACH ROW WHEN ((old."eventPoints" IS DISTINCT FROM new."eventPoints")) EXECUTE FUNCTION public.update_user_points_from_event_change();
 @   DROP TRIGGER update_points_after_event_update ON public.events;
       public          test_app    false    203    203    223            �           2620    16510 +   points update_points_after_insert_or_update    TRIGGER     �   CREATE TRIGGER update_points_after_insert_or_update AFTER INSERT OR UPDATE ON public.points FOR EACH ROW EXECUTE FUNCTION public.update_user_total_points();
 D   DROP TRIGGER update_points_after_insert_or_update ON public.points;
       public          test_app    false    209    225            �           2606    16477    rsvps fk_rails_115d52081c    FK CONSTRAINT     z   ALTER TABLE ONLY public.rsvps
    ADD CONSTRAINT fk_rails_115d52081c FOREIGN KEY (event_id) REFERENCES public.events(id);
 C   ALTER TABLE ONLY public.rsvps DROP CONSTRAINT fk_rails_115d52081c;
       public          test_app    false    2945    203    211            �           2606    16504    attendances fk_rails_67d4100843    FK CONSTRAINT     �   ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT fk_rails_67d4100843 FOREIGN KEY ("eventID") REFERENCES public.events(id);
 I   ALTER TABLE ONLY public.attendances DROP CONSTRAINT fk_rails_67d4100843;
       public          test_app    false    203    2945    213            �           2606    16577 !   announcements fk_rails_94e3afa72b    FK CONSTRAINT     �   ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT fk_rails_94e3afa72b FOREIGN KEY ("googleUserID") REFERENCES public.users(uid) ON DELETE SET NULL;
 K   ALTER TABLE ONLY public.announcements DROP CONSTRAINT fk_rails_94e3afa72b;
       public          test_app    false    2949    207    204            �           2606    16559 2   active_storage_variant_records fk_rails_993965df05    FK CONSTRAINT     �   ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);
 \   ALTER TABLE ONLY public.active_storage_variant_records DROP CONSTRAINT fk_rails_993965df05;
       public          test_app    false    2960    219    215            �           2606    16587    points fk_rails_9cc02d9953    FK CONSTRAINT     �   ALTER TABLE ONLY public.points
    ADD CONSTRAINT fk_rails_9cc02d9953 FOREIGN KEY ("awardedTo") REFERENCES public.users(uid) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.points DROP CONSTRAINT fk_rails_9cc02d9953;
       public          test_app    false    209    207    2949            �           2606    16541 .   active_storage_attachments fk_rails_c3b3935057    FK CONSTRAINT     �   ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);
 X   ALTER TABLE ONLY public.active_storage_attachments DROP CONSTRAINT fk_rails_c3b3935057;
       public          test_app    false    215    217    2960            �           2606    16582    attendances fk_rails_c47ec2e1a2    FK CONSTRAINT     �   ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT fk_rails_c47ec2e1a2 FOREIGN KEY ("googleUserID") REFERENCES public.users(uid) ON DELETE SET NULL;
 I   ALTER TABLE ONLY public.attendances DROP CONSTRAINT fk_rails_c47ec2e1a2;
       public          test_app    false    213    2949    207            �           2606    16483    rsvps fk_rails_fbc918ec10    FK CONSTRAINT     �   ALTER TABLE ONLY public.rsvps
    ADD CONSTRAINT fk_rails_fbc918ec10 FOREIGN KEY (user_uid) REFERENCES public.users(uid) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.rsvps DROP CONSTRAINT fk_rails_fbc918ec10;
       public          test_app    false    211    207    2949            @      x������ � �      <      x������ � �      :      x������ � �      >      x������ � �      /      x������ � �      ,   ?   x�K�+�,���M�+�LI-K��/ ���Lt�u�-�Lͭ��L�L���Hq��qqq ��f      8      x������ � �      .      x������ � �      4      x������ � �      6      x������ � �      +   �   x�U��B1�}�����^�Qy��a�G�C� "�З[2�7�x��'fS�ڇU�b�K���532��U��6���;�9��wx��aԨ�h�E5��>&ʹ~�Ky(2��ҹ}�쭘u��ѓy��Z��c���>A       2      x������ � �     