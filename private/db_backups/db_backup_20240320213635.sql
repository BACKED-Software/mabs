PGDMP     #    $                |            mcabs_tracker_development    13.7 (Debian 13.7-0+deb11u1)    13.7 (Debian 13.7-0+deb11u1) h    B           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            C           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            D           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            E           1262    147510    mcabs_tracker_development    DATABASE     j   CREATE DATABASE mcabs_tracker_development WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'C.UTF-8';
 )   DROP DATABASE mcabs_tracker_development;
                test_app    false            �            1255    172036    update_attendance_points()    FUNCTION     :  CREATE FUNCTION public.update_attendance_points() RETURNS trigger
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
       public          test_app    false            �            1255    172034 &   update_user_points_from_event_change()    FUNCTION     !  CREATE FUNCTION public.update_user_points_from_event_change() RETURNS trigger
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
       public          test_app    false            �            1255    163840    update_user_total_points()    FUNCTION     �  CREATE FUNCTION public.update_user_total_points() RETURNS trigger
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
       public          test_app    false            �            1255    172032 *   update_user_total_points_from_attendance()    FUNCTION     �  CREATE FUNCTION public.update_user_total_points_from_attendance() RETURNS trigger
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
       public          test_app    false            �            1259    172087    action_text_rich_texts    TABLE     6  CREATE TABLE public.action_text_rich_texts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    body text,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 *   DROP TABLE public.action_text_rich_texts;
       public         heap    test_app    false            �            1259    172085    action_text_rich_texts_id_seq    SEQUENCE     �   CREATE SEQUENCE public.action_text_rich_texts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.action_text_rich_texts_id_seq;
       public          test_app    false    221            F           0    0    action_text_rich_texts_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.action_text_rich_texts_id_seq OWNED BY public.action_text_rich_texts.id;
          public          test_app    false    220            �            1259    172052    active_storage_attachments    TABLE       CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);
 .   DROP TABLE public.active_storage_attachments;
       public         heap    test_app    false            �            1259    172050 !   active_storage_attachments_id_seq    SEQUENCE     �   CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.active_storage_attachments_id_seq;
       public          test_app    false    217            G           0    0 !   active_storage_attachments_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;
          public          test_app    false    216            �            1259    172040    active_storage_blobs    TABLE     m  CREATE TABLE public.active_storage_blobs (
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
       public         heap    test_app    false            �            1259    172038    active_storage_blobs_id_seq    SEQUENCE     �   CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.active_storage_blobs_id_seq;
       public          test_app    false    215            H           0    0    active_storage_blobs_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;
          public          test_app    false    214            �            1259    172070    active_storage_variant_records    TABLE     �   CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);
 2   DROP TABLE public.active_storage_variant_records;
       public         heap    test_app    false            �            1259    172068 %   active_storage_variant_records_id_seq    SEQUENCE     �   CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public.active_storage_variant_records_id_seq;
       public          test_app    false    219            I           0    0 %   active_storage_variant_records_id_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;
          public          test_app    false    218            �            1259    147514    announcements    TABLE     <  CREATE TABLE public.announcements (
    "announcementID" bigint NOT NULL,
    "googleUserID" character varying,
    subject text,
    "dateOfAnnouncement" timestamp(6) without time zone,
    body text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 !   DROP TABLE public.announcements;
       public         heap    test_app    false            �            1259    147512     announcements_announcementID_seq    SEQUENCE     �   CREATE SEQUENCE public."announcements_announcementID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public."announcements_announcementID_seq";
       public          test_app    false    201            J           0    0     announcements_announcementID_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public."announcements_announcementID_seq" OWNED BY public.announcements."announcementID";
          public          test_app    false    200            �            1259    147615    ar_internal_metadata    TABLE     �   CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 (   DROP TABLE public.ar_internal_metadata;
       public         heap    test_app    false            �            1259    147525    attendances    TABLE     -  CREATE TABLE public.attendances (
    id bigint NOT NULL,
    "eventID" integer,
    "googleUserID" text,
    "timeOfCheckIn" timestamp(6) without time zone,
    "pointsAwarded" integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
    DROP TABLE public.attendances;
       public         heap    test_app    false            �            1259    147523    attendances_id_seq    SEQUENCE     {   CREATE SEQUENCE public.attendances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.attendances_id_seq;
       public          test_app    false    203            K           0    0    attendances_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.attendances_id_seq OWNED BY public.attendances.id;
          public          test_app    false    202            �            1259    147536    events    TABLE     �  CREATE TABLE public.events (
    id bigint NOT NULL,
    "eventLocation" text,
    "eventInfo" text,
    "eventName" character varying,
    "eventTime" timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    sponsor_title character varying,
    sponsor_description text,
    password character varying,
    "eventPoints" integer
);
    DROP TABLE public.events;
       public         heap    test_app    false            �            1259    147534    events_id_seq    SEQUENCE     v   CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.events_id_seq;
       public          test_app    false    205            L           0    0    events_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;
          public          test_app    false    204            �            1259    147547    points    TABLE     \  CREATE TABLE public.points (
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
       public         heap    test_app    false            �            1259    147545    points_id_seq    SEQUENCE     v   CREATE SEQUENCE public.points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.points_id_seq;
       public          test_app    false    207            M           0    0    points_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.points_id_seq OWNED BY public.points.id;
          public          test_app    false    206            �            1259    147558    rsvps    TABLE     �   CREATE TABLE public.rsvps (
    id bigint NOT NULL,
    user_uid character varying,
    event_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
    DROP TABLE public.rsvps;
       public         heap    test_app    false            �            1259    147556    rsvps_id_seq    SEQUENCE     u   CREATE SEQUENCE public.rsvps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.rsvps_id_seq;
       public          test_app    false    209            N           0    0    rsvps_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.rsvps_id_seq OWNED BY public.rsvps.id;
          public          test_app    false    208            �            1259    147607    schema_migrations    TABLE     R   CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);
 %   DROP TABLE public.schema_migrations;
       public         heap    test_app    false            �            1259    147570    users    TABLE     �  CREATE TABLE public.users (
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
       public         heap    test_app    false            �            1259    147568    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          test_app    false    211            O           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          test_app    false    210            {           2604    172090    action_text_rich_texts id    DEFAULT     �   ALTER TABLE ONLY public.action_text_rich_texts ALTER COLUMN id SET DEFAULT nextval('public.action_text_rich_texts_id_seq'::regclass);
 H   ALTER TABLE public.action_text_rich_texts ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    221    220    221            y           2604    172055    active_storage_attachments id    DEFAULT     �   ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);
 L   ALTER TABLE public.active_storage_attachments ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    217    216    217            x           2604    172043    active_storage_blobs id    DEFAULT     �   ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);
 F   ALTER TABLE public.active_storage_blobs ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    214    215    215            z           2604    172073 !   active_storage_variant_records id    DEFAULT     �   ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);
 P   ALTER TABLE public.active_storage_variant_records ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    218    219    219            q           2604    147517    announcements announcementID    DEFAULT     �   ALTER TABLE ONLY public.announcements ALTER COLUMN "announcementID" SET DEFAULT nextval('public."announcements_announcementID_seq"'::regclass);
 M   ALTER TABLE public.announcements ALTER COLUMN "announcementID" DROP DEFAULT;
       public          test_app    false    201    200    201            r           2604    147528    attendances id    DEFAULT     p   ALTER TABLE ONLY public.attendances ALTER COLUMN id SET DEFAULT nextval('public.attendances_id_seq'::regclass);
 =   ALTER TABLE public.attendances ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    202    203    203            s           2604    147539 	   events id    DEFAULT     f   ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);
 8   ALTER TABLE public.events ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    205    204    205            t           2604    147550 	   points id    DEFAULT     f   ALTER TABLE ONLY public.points ALTER COLUMN id SET DEFAULT nextval('public.points_id_seq'::regclass);
 8   ALTER TABLE public.points ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    207    206    207            u           2604    147561    rsvps id    DEFAULT     d   ALTER TABLE ONLY public.rsvps ALTER COLUMN id SET DEFAULT nextval('public.rsvps_id_seq'::regclass);
 7   ALTER TABLE public.rsvps ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    209    208    209            v           2604    147573    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    211    210    211            ?          0    172087    action_text_rich_texts 
   TABLE DATA           p   COPY public.action_text_rich_texts (id, name, body, record_type, record_id, created_at, updated_at) FROM stdin;
    public          test_app    false    221   �       ;          0    172052    active_storage_attachments 
   TABLE DATA           k   COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
    public          test_app    false    217   w�       9          0    172040    active_storage_blobs 
   TABLE DATA           �   COPY public.active_storage_blobs (id, key, filename, content_type, metadata, service_name, byte_size, checksum, created_at) FROM stdin;
    public          test_app    false    215   ��       =          0    172070    active_storage_variant_records 
   TABLE DATA           W   COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
    public          test_app    false    219   ��       +          0    147514    announcements 
   TABLE DATA           �   COPY public.announcements ("announcementID", "googleUserID", subject, "dateOfAnnouncement", body, created_at, updated_at) FROM stdin;
    public          test_app    false    201   ΍       7          0    147615    ar_internal_metadata 
   TABLE DATA           R   COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
    public          test_app    false    213   =�       -          0    147525    attendances 
   TABLE DATA           ~   COPY public.attendances (id, "eventID", "googleUserID", "timeOfCheckIn", "pointsAwarded", created_at, updated_at) FROM stdin;
    public          test_app    false    203          /          0    147536    events 
   TABLE DATA           �   COPY public.events (id, "eventLocation", "eventInfo", "eventName", "eventTime", created_at, updated_at, sponsor_title, sponsor_description, password, "eventPoints") FROM stdin;
    public          test_app    false    205   ߎ       1          0    147547    points 
   TABLE DATA           �   COPY public.points (id, "numPointsAwarded", "awardedBy", "awardedTo", "dateOfAward", "awardDescription", created_at, updated_at) FROM stdin;
    public          test_app    false    207   C�       3          0    147558    rsvps 
   TABLE DATA           O   COPY public.rsvps (id, user_uid, event_id, created_at, updated_at) FROM stdin;
    public          test_app    false    209   `�       6          0    147607    schema_migrations 
   TABLE DATA           4   COPY public.schema_migrations (version) FROM stdin;
    public          test_app    false    212   ��       5          0    147570    users 
   TABLE DATA             COPY public.users (id, uid, email, is_admin, full_name, middle_initial, gender, is_hispanic_or_latino, race, is_us_citizen, is_first_generation_college_student, date_of_birth, phone_number, avatar_url, bio, classification, total_points, created_at, updated_at, role) FROM stdin;
    public          test_app    false    211   ?�       P           0    0    action_text_rich_texts_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.action_text_rich_texts_id_seq', 2, true);
          public          test_app    false    220            Q           0    0 !   active_storage_attachments_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 1, false);
          public          test_app    false    216            R           0    0    active_storage_blobs_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 1, false);
          public          test_app    false    214            S           0    0 %   active_storage_variant_records_id_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 1, false);
          public          test_app    false    218            T           0    0     announcements_announcementID_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public."announcements_announcementID_seq"', 6, true);
          public          test_app    false    200            U           0    0    attendances_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.attendances_id_seq', 2, true);
          public          test_app    false    202            V           0    0    events_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.events_id_seq', 10, true);
          public          test_app    false    204            W           0    0    points_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.points_id_seq', 1, false);
          public          test_app    false    206            X           0    0    rsvps_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.rsvps_id_seq', 4, true);
          public          test_app    false    208            Y           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 2, true);
          public          test_app    false    210            �           2606    172095 2   action_text_rich_texts action_text_rich_texts_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.action_text_rich_texts
    ADD CONSTRAINT action_text_rich_texts_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.action_text_rich_texts DROP CONSTRAINT action_text_rich_texts_pkey;
       public            test_app    false    221            �           2606    172060 :   active_storage_attachments active_storage_attachments_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.active_storage_attachments DROP CONSTRAINT active_storage_attachments_pkey;
       public            test_app    false    217            �           2606    172048 .   active_storage_blobs active_storage_blobs_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.active_storage_blobs DROP CONSTRAINT active_storage_blobs_pkey;
       public            test_app    false    215            �           2606    172078 B   active_storage_variant_records active_storage_variant_records_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);
 l   ALTER TABLE ONLY public.active_storage_variant_records DROP CONSTRAINT active_storage_variant_records_pkey;
       public            test_app    false    219            }           2606    147522     announcements announcements_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY ("announcementID");
 J   ALTER TABLE ONLY public.announcements DROP CONSTRAINT announcements_pkey;
       public            test_app    false    201            �           2606    147622 .   ar_internal_metadata ar_internal_metadata_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);
 X   ALTER TABLE ONLY public.ar_internal_metadata DROP CONSTRAINT ar_internal_metadata_pkey;
       public            test_app    false    213                       2606    147533    attendances attendances_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.attendances DROP CONSTRAINT attendances_pkey;
       public            test_app    false    203            �           2606    147544    events events_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.events DROP CONSTRAINT events_pkey;
       public            test_app    false    205            �           2606    147555    points points_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.points
    ADD CONSTRAINT points_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.points DROP CONSTRAINT points_pkey;
       public            test_app    false    207            �           2606    147566    rsvps rsvps_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.rsvps
    ADD CONSTRAINT rsvps_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.rsvps DROP CONSTRAINT rsvps_pkey;
       public            test_app    false    209            �           2606    147614 (   schema_migrations schema_migrations_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
 R   ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
       public            test_app    false    212            �           2606    147579    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            test_app    false    211            �           1259    172096 '   index_action_text_rich_texts_uniqueness    INDEX     �   CREATE UNIQUE INDEX index_action_text_rich_texts_uniqueness ON public.action_text_rich_texts USING btree (record_type, record_id, name);
 ;   DROP INDEX public.index_action_text_rich_texts_uniqueness;
       public            test_app    false    221    221    221            �           1259    172066 +   index_active_storage_attachments_on_blob_id    INDEX     u   CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);
 ?   DROP INDEX public.index_active_storage_attachments_on_blob_id;
       public            test_app    false    217            �           1259    172067 +   index_active_storage_attachments_uniqueness    INDEX     �   CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);
 ?   DROP INDEX public.index_active_storage_attachments_uniqueness;
       public            test_app    false    217    217    217    217            �           1259    172049 !   index_active_storage_blobs_on_key    INDEX     h   CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);
 5   DROP INDEX public.index_active_storage_blobs_on_key;
       public            test_app    false    215            �           1259    172084 /   index_active_storage_variant_records_uniqueness    INDEX     �   CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);
 C   DROP INDEX public.index_active_storage_variant_records_uniqueness;
       public            test_app    false    219    219            �           1259    147567    index_rsvps_on_event_id    INDEX     M   CREATE INDEX index_rsvps_on_event_id ON public.rsvps USING btree (event_id);
 +   DROP INDEX public.index_rsvps_on_event_id;
       public            test_app    false    209            �           1259    147580    index_users_on_email    INDEX     N   CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);
 (   DROP INDEX public.index_users_on_email;
       public            test_app    false    211            �           1259    147581    index_users_on_uid    INDEX     J   CREATE UNIQUE INDEX index_users_on_uid ON public.users USING btree (uid);
 &   DROP INDEX public.index_users_on_uid;
       public            test_app    false    211            �           2620    172037 2   events update_attendance_points_after_event_update    TRIGGER     �   CREATE TRIGGER update_attendance_points_after_event_update AFTER UPDATE OF "eventPoints" ON public.events FOR EACH ROW EXECUTE FUNCTION public.update_attendance_points();
 K   DROP TRIGGER update_attendance_points_after_event_update ON public.events;
       public          test_app    false    205    224    205            �           2620    172033 *   attendances update_points_after_attendance    TRIGGER     �   CREATE TRIGGER update_points_after_attendance AFTER INSERT ON public.attendances FOR EACH ROW EXECUTE FUNCTION public.update_user_total_points_from_attendance();
 C   DROP TRIGGER update_points_after_attendance ON public.attendances;
       public          test_app    false    203    222            �           2620    163842 !   points update_points_after_delete    TRIGGER     �   CREATE TRIGGER update_points_after_delete AFTER DELETE ON public.points FOR EACH ROW EXECUTE FUNCTION public.update_user_total_points();
 :   DROP TRIGGER update_points_after_delete ON public.points;
       public          test_app    false    225    207            �           2620    172035 '   events update_points_after_event_update    TRIGGER     �   CREATE TRIGGER update_points_after_event_update AFTER UPDATE ON public.events FOR EACH ROW WHEN ((old."eventPoints" IS DISTINCT FROM new."eventPoints")) EXECUTE FUNCTION public.update_user_points_from_event_change();
 @   DROP TRIGGER update_points_after_event_update ON public.events;
       public          test_app    false    223    205    205            �           2620    163841 +   points update_points_after_insert_or_update    TRIGGER     �   CREATE TRIGGER update_points_after_insert_or_update AFTER INSERT OR UPDATE ON public.points FOR EACH ROW EXECUTE FUNCTION public.update_user_total_points();
 D   DROP TRIGGER update_points_after_insert_or_update ON public.points;
       public          test_app    false    225    207            �           2606    147597    rsvps fk_rails_115d52081c    FK CONSTRAINT     z   ALTER TABLE ONLY public.rsvps
    ADD CONSTRAINT fk_rails_115d52081c FOREIGN KEY (event_id) REFERENCES public.events(id);
 C   ALTER TABLE ONLY public.rsvps DROP CONSTRAINT fk_rails_115d52081c;
       public          test_app    false    205    209    2945            �           2606    147587    attendances fk_rails_67d4100843    FK CONSTRAINT     �   ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT fk_rails_67d4100843 FOREIGN KEY ("eventID") REFERENCES public.events(id);
 I   ALTER TABLE ONLY public.attendances DROP CONSTRAINT fk_rails_67d4100843;
       public          test_app    false    205    2945    203            �           2606    147582 !   announcements fk_rails_94e3afa72b    FK CONSTRAINT     �   ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT fk_rails_94e3afa72b FOREIGN KEY ("googleUserID") REFERENCES public.users(uid);
 K   ALTER TABLE ONLY public.announcements DROP CONSTRAINT fk_rails_94e3afa72b;
       public          test_app    false    211    2952    201            �           2606    172079 2   active_storage_variant_records fk_rails_993965df05    FK CONSTRAINT     �   ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);
 \   ALTER TABLE ONLY public.active_storage_variant_records DROP CONSTRAINT fk_rails_993965df05;
       public          test_app    false    2960    215    219            �           2606    172061 .   active_storage_attachments fk_rails_c3b3935057    FK CONSTRAINT     �   ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);
 X   ALTER TABLE ONLY public.active_storage_attachments DROP CONSTRAINT fk_rails_c3b3935057;
       public          test_app    false    215    217    2960            �           2606    147592    attendances fk_rails_c47ec2e1a2    FK CONSTRAINT     �   ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT fk_rails_c47ec2e1a2 FOREIGN KEY ("googleUserID") REFERENCES public.users(uid);
 I   ALTER TABLE ONLY public.attendances DROP CONSTRAINT fk_rails_c47ec2e1a2;
       public          test_app    false    2952    211    203            �           2606    147602    rsvps fk_rails_fbc918ec10    FK CONSTRAINT     �   ALTER TABLE ONLY public.rsvps
    ADD CONSTRAINT fk_rails_fbc918ec10 FOREIGN KEY (user_uid) REFERENCES public.users(uid) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.rsvps DROP CONSTRAINT fk_rails_fbc918ec10;
       public          test_app    false    209    211    2952            ?   u   x�3�L�O��I�,�s��K/-VH����SH�/:�����(?/��&5�.�?�FH��Cm�A�8���K�SsS�J8�8��Lt�u�-�LM�L�LL�-�Hq��qqq � '�      ;      x������ � �      9      x������ � �      =      x������ � �      +   _   x�uɻ� ��`�{p�v�N@c���&��z�3���2(�9��b~�~�MMc��Zo��,49�Aq.l 
�����K�B��H)_)y      7   u   x�}�Q
�0��gs�]@I����e0jq0������o?|�[=��Z��F�����ڡ�-r��~`(t�$C��ٖ���L�%Y�*���nb*4�E��9���O8r�!xv p�	-�      -      x������ � �      /   T  x�}�Mo�0�����.�Q���4��:Ti�!@�6�� %���i�~�U�1�O����c'�7m��k��/����ыV%+�oX))XVo����`Ԗ���4w��Z�ը��e��h:��LV���U�k!Wj����l���]�\B���z!
�"=� (A���@�B#�	���5�1��uE��� ���v�P��(i���N�hX��<������@á�>g"���Ӕ�x��yBQ7�~LqHQ�I��u�?k��LM�*�XO��x�'��#>Fg�o�o�����	��a��Vs(�2�q�#pJ�z�A�iB�5���,Pq�Т�Bɿ�F��|��ݪ�Z      1      x������ � �      3   ?   x�}���0�w���9�C$���:����zP�MJH��AP1���y�����~��2��4�      6   �   x�U��1��a$�N�^�|p�\K3J9!""�.
(�fJF�K3��uqb6ŴPV
��.Y��+6��1c�)'��C��i�.G���Ί�_u5u]��fZ?��}(2,������|�1^�2;�      5   �   x�m��j�0���Ux�_�/�
�RJJ)��Zݪ�hdlW�2Ǝ����� �Re��2G� UD���ަ�xo'�ف���h.���!���Ύ��t��gE}G�u��en�ڍ����٨ش���پ�}U����<���
~6�{q�f��M"'����׿`�8�4DԀ�@Ŕ�?��Ԅ:�"!R)=��QA��BC     