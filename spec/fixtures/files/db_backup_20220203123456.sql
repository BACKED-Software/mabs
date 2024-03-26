PGDMP         3                |            mcabs_tracker_development    13.7 (Debian 13.7-0+deb11u1)    13.7 (Debian 13.7-0+deb11u1) o    I           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            J           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            K           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            L           1262    16385    mcabs_tracker_development    DATABASE     j   CREATE DATABASE mcabs_tracker_development WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'C.UTF-8';
 )   DROP DATABASE mcabs_tracker_development;
                test_app    false                        2615    18492    _heroku    SCHEMA        CREATE SCHEMA _heroku;
    DROP SCHEMA _heroku;
                test_app    false                        2615    18493 
   heroku_ext    SCHEMA        CREATE SCHEMA heroku_ext;
    DROP SCHEMA heroku_ext;
                test_app    false            �            1255    18495    create_ext()    FUNCTION     �  CREATE FUNCTION _heroku.create_ext() RETURNS event_trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$

DECLARE

  schemaname TEXT;
  databaseowner TEXT;

  r RECORD;

BEGIN

  IF tg_tag = 'CREATE EXTENSION' and current_user != 'rds_superuser' THEN
    FOR r IN SELECT * FROM pg_event_trigger_ddl_commands()
    LOOP
        CONTINUE WHEN r.command_tag != 'CREATE EXTENSION' OR r.object_type != 'extension';

        schemaname = (
            SELECT n.nspname
            FROM pg_catalog.pg_extension AS e
            INNER JOIN pg_catalog.pg_namespace AS n
            ON e.extnamespace = n.oid
            WHERE e.oid = r.objid
        );

        databaseowner = (
            SELECT pg_catalog.pg_get_userbyid(d.datdba)
            FROM pg_catalog.pg_database d
            WHERE d.datname = current_database()
        );
        --RAISE NOTICE 'Record for event trigger %, objid: %,tag: %, current_user: %, schema: %, database_owenr: %', r.object_identity, r.objid, tg_tag, current_user, schemaname, databaseowner;
        IF r.object_identity = 'address_standardizer_data_us' THEN
            EXECUTE format('GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE %I.us_gaz TO %I;', schemaname, databaseowner);
            EXECUTE format('GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE %I.us_lex TO %I;', schemaname, databaseowner);
            EXECUTE format('GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE %I.us_rules TO %I;', schemaname, databaseowner);
        ELSIF r.object_identity = 'amcheck' THEN
            EXECUTE format('GRANT EXECUTE ON FUNCTION %I.bt_index_check TO %I;', schemaname, databaseowner);
            EXECUTE format('GRANT EXECUTE ON FUNCTION %I.bt_index_parent_check TO %I;', schemaname, databaseowner);
        ELSIF r.object_identity = 'dict_int' THEN
            EXECUTE format('ALTER TEXT SEARCH DICTIONARY %I.intdict OWNER TO %I;', schemaname, databaseowner);
        ELSIF r.object_identity = 'pg_partman' THEN
            EXECUTE format('GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE %I.part_config TO %I;', schemaname, databaseowner);
            EXECUTE format('GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE %I.part_config_sub TO %I;', schemaname, databaseowner);
            EXECUTE format('GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE %I.custom_time_partitions TO %I;', schemaname, databaseowner);
        ELSIF r.object_identity = 'pg_stat_statements' THEN
            EXECUTE format('GRANT EXECUTE ON FUNCTION %I.pg_stat_statements_reset TO %I;', schemaname, databaseowner);
        ELSIF r.object_identity = 'postgis' THEN
            PERFORM _heroku.postgis_after_create();
        ELSIF r.object_identity = 'postgis_raster' THEN
            PERFORM _heroku.postgis_after_create();
            EXECUTE format('GRANT SELECT ON TABLE %I.raster_columns TO %I;', schemaname, databaseowner);
            EXECUTE format('GRANT SELECT ON TABLE %I.raster_overviews TO %I;', schemaname, databaseowner);
        ELSIF r.object_identity = 'postgis_topology' THEN
            PERFORM _heroku.postgis_after_create();
            EXECUTE format('GRANT USAGE ON SCHEMA topology TO %I;', databaseowner);
            EXECUTE format('GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA topology TO %I;', databaseowner);
            EXECUTE format('GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA topology TO %I;', databaseowner);
            EXECUTE format('GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA topology TO %I;', databaseowner);
        ELSIF r.object_identity = 'postgis_tiger_geocoder' THEN
            PERFORM _heroku.postgis_after_create();
            EXECUTE format('GRANT USAGE ON SCHEMA tiger TO %I;', databaseowner);
            EXECUTE format('GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA tiger TO %I;', databaseowner);
            EXECUTE format('GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA tiger TO %I;', databaseowner);

            EXECUTE format('GRANT USAGE ON SCHEMA tiger_data TO %I;', databaseowner);
            EXECUTE format('GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA tiger_data TO %I;', databaseowner);
            EXECUTE format('GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA tiger_data TO %I;', databaseowner);
        END IF;
    END LOOP;
  END IF;
END;
$$;
 $   DROP FUNCTION _heroku.create_ext();
       _heroku          test_app    false    5            �            1255    18496 
   drop_ext()    FUNCTION     �  CREATE FUNCTION _heroku.drop_ext() RETURNS event_trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$

DECLARE

  schemaname TEXT;
  databaseowner TEXT;

  r RECORD;

BEGIN

  IF tg_tag = 'DROP EXTENSION' and current_user != 'rds_superuser' THEN
    FOR r IN SELECT * FROM pg_event_trigger_dropped_objects()
    LOOP
      CONTINUE WHEN r.object_type != 'extension';

      databaseowner = (
            SELECT pg_catalog.pg_get_userbyid(d.datdba)
            FROM pg_catalog.pg_database d
            WHERE d.datname = current_database()
      );

      --RAISE NOTICE 'Record for event trigger %, objid: %,tag: %, current_user: %, database_owner: %, schemaname: %', r.object_identity, r.objid, tg_tag, current_user, databaseowner, r.schema_name;

      IF r.object_identity = 'postgis_topology' THEN
          EXECUTE format('DROP SCHEMA IF EXISTS topology');
      END IF;
    END LOOP;

  END IF;
END;
$$;
 "   DROP FUNCTION _heroku.drop_ext();
       _heroku          test_app    false    5            �            1255    18497    postgis_after_create()    FUNCTION        CREATE FUNCTION _heroku.postgis_after_create() RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    schemaname TEXT;
    databaseowner TEXT;
BEGIN
    schemaname = (
        SELECT n.nspname
        FROM pg_catalog.pg_extension AS e
        INNER JOIN pg_catalog.pg_namespace AS n ON e.extnamespace = n.oid
        WHERE e.extname = 'postgis'
    );
    databaseowner = (
        SELECT pg_catalog.pg_get_userbyid(d.datdba)
        FROM pg_catalog.pg_database d
        WHERE d.datname = current_database()
    );

    EXECUTE format('GRANT EXECUTE ON FUNCTION %I.st_tileenvelope TO %I;', schemaname, databaseowner);
    EXECUTE format('GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE %I.spatial_ref_sys TO %I;', schemaname, databaseowner);
END;
$$;
 .   DROP FUNCTION _heroku.postgis_after_create();
       _heroku          test_app    false    5            �            1255    18498    validate_extension()    FUNCTION       CREATE FUNCTION _heroku.validate_extension() RETURNS event_trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$

DECLARE

  schemaname TEXT;
  r RECORD;

BEGIN

  IF tg_tag = 'CREATE EXTENSION' and current_user != 'rds_superuser' THEN
    FOR r IN SELECT * FROM pg_event_trigger_ddl_commands()
    LOOP
      CONTINUE WHEN r.command_tag != 'CREATE EXTENSION' OR r.object_type != 'extension';

      schemaname = (
        SELECT n.nspname
        FROM pg_catalog.pg_extension AS e
        INNER JOIN pg_catalog.pg_namespace AS n
        ON e.extnamespace = n.oid
        WHERE e.oid = r.objid
      );

      IF schemaname = '_heroku' THEN
        RAISE EXCEPTION 'Creating extensions in the _heroku schema is not allowed';
      END IF;
    END LOOP;
  END IF;
END;
$$;
 ,   DROP FUNCTION _heroku.validate_extension();
       _heroku          test_app    false    5            �            1255    18499    update_attendance_points()    FUNCTION     :  CREATE FUNCTION public.update_attendance_points() RETURNS trigger
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
       public          test_app    false            �            1255    18500 &   update_user_points_from_event_change()    FUNCTION     !  CREATE FUNCTION public.update_user_points_from_event_change() RETURNS trigger
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
       public          test_app    false            �            1255    18501    update_user_total_points()    FUNCTION     �  CREATE FUNCTION public.update_user_total_points() RETURNS trigger
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
       public          test_app    false            �            1255    18502 *   update_user_total_points_from_attendance()    FUNCTION     �  CREATE FUNCTION public.update_user_total_points_from_attendance() RETURNS trigger
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
       public          test_app    false            �            1259    18503    action_text_rich_texts    TABLE     6  CREATE TABLE public.action_text_rich_texts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    body text,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 *   DROP TABLE public.action_text_rich_texts;
       public         heap    test_app    false            �            1259    18509    action_text_rich_texts_id_seq    SEQUENCE     �   CREATE SEQUENCE public.action_text_rich_texts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.action_text_rich_texts_id_seq;
       public          test_app    false    202            M           0    0    action_text_rich_texts_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.action_text_rich_texts_id_seq OWNED BY public.action_text_rich_texts.id;
          public          test_app    false    203            �            1259    18511    active_storage_attachments    TABLE       CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);
 .   DROP TABLE public.active_storage_attachments;
       public         heap    test_app    false            �            1259    18517 !   active_storage_attachments_id_seq    SEQUENCE     �   CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.active_storage_attachments_id_seq;
       public          test_app    false    204            N           0    0 !   active_storage_attachments_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;
          public          test_app    false    205            �            1259    18519    active_storage_blobs    TABLE     m  CREATE TABLE public.active_storage_blobs (
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
       public         heap    test_app    false            �            1259    18525    active_storage_blobs_id_seq    SEQUENCE     �   CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.active_storage_blobs_id_seq;
       public          test_app    false    206            O           0    0    active_storage_blobs_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;
          public          test_app    false    207            �            1259    18527    active_storage_variant_records    TABLE     �   CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);
 2   DROP TABLE public.active_storage_variant_records;
       public         heap    test_app    false            �            1259    18533 %   active_storage_variant_records_id_seq    SEQUENCE     �   CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public.active_storage_variant_records_id_seq;
       public          test_app    false    208            P           0    0 %   active_storage_variant_records_id_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;
          public          test_app    false    209            �            1259    18535    announcements    TABLE     <  CREATE TABLE public.announcements (
    "googleUserID" character varying,
    subject text,
    "dateOfAnnouncement" timestamp(6) without time zone,
    body text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    "announcementID" bigint NOT NULL
);
 !   DROP TABLE public.announcements;
       public         heap    test_app    false            �            1259    18541     announcements_announcementID_seq    SEQUENCE     �   CREATE SEQUENCE public."announcements_announcementID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public."announcements_announcementID_seq";
       public          test_app    false    210            Q           0    0     announcements_announcementID_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public."announcements_announcementID_seq" OWNED BY public.announcements."announcementID";
          public          test_app    false    211            �            1259    18543    ar_internal_metadata    TABLE     �   CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
 (   DROP TABLE public.ar_internal_metadata;
       public         heap    test_app    false            �            1259    18549    attendances    TABLE     -  CREATE TABLE public.attendances (
    id bigint NOT NULL,
    "eventID" integer,
    "googleUserID" text,
    "timeOfCheckIn" timestamp(6) without time zone,
    "pointsAwarded" integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
    DROP TABLE public.attendances;
       public         heap    test_app    false            �            1259    18555    attendances_id_seq    SEQUENCE     {   CREATE SEQUENCE public.attendances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.attendances_id_seq;
       public          test_app    false    213            R           0    0    attendances_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.attendances_id_seq OWNED BY public.attendances.id;
          public          test_app    false    214            �            1259    18557    events    TABLE     �  CREATE TABLE public.events (
    id bigint NOT NULL,
    "eventLocation" text,
    "eventInfo" text,
    "eventName" character varying,
    "eventTime" timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    "eventPoints" integer,
    sponsor_title character varying,
    sponsor_description text,
    password character varying
);
    DROP TABLE public.events;
       public         heap    test_app    false            �            1259    18563    events_id_seq    SEQUENCE     v   CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.events_id_seq;
       public          test_app    false    215            S           0    0    events_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;
          public          test_app    false    216            �            1259    18565    points    TABLE     s  CREATE TABLE public.points (
    id bigint NOT NULL,
    "numPointsAwarded" integer,
    "awardedBy" character varying,
    "awardedTo" character varying,
    "dateOfAward" timestamp(6) without time zone,
    "awardDescription" text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    "PointID" integer
);
    DROP TABLE public.points;
       public         heap    test_app    false            �            1259    18571    points_id_seq    SEQUENCE     v   CREATE SEQUENCE public.points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.points_id_seq;
       public          test_app    false    217            T           0    0    points_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.points_id_seq OWNED BY public.points.id;
          public          test_app    false    218            �            1259    18573    rsvps    TABLE     �   CREATE TABLE public.rsvps (
    id bigint NOT NULL,
    user_uid character varying,
    event_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
    DROP TABLE public.rsvps;
       public         heap    test_app    false            �            1259    18579    rsvps_id_seq    SEQUENCE     u   CREATE SEQUENCE public.rsvps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.rsvps_id_seq;
       public          test_app    false    219            U           0    0    rsvps_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.rsvps_id_seq OWNED BY public.rsvps.id;
          public          test_app    false    220            �            1259    18581    schema_migrations    TABLE     R   CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);
 %   DROP TABLE public.schema_migrations;
       public         heap    test_app    false            �            1259    18587    users    TABLE     �  CREATE TABLE public.users (
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
       public         heap    test_app    false            �            1259    18594    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          test_app    false    222            V           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          test_app    false    223            w           2604    18596    action_text_rich_texts id    DEFAULT     �   ALTER TABLE ONLY public.action_text_rich_texts ALTER COLUMN id SET DEFAULT nextval('public.action_text_rich_texts_id_seq'::regclass);
 H   ALTER TABLE public.action_text_rich_texts ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    203    202            x           2604    18597    active_storage_attachments id    DEFAULT     �   ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);
 L   ALTER TABLE public.active_storage_attachments ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    205    204            y           2604    18598    active_storage_blobs id    DEFAULT     �   ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);
 F   ALTER TABLE public.active_storage_blobs ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    207    206            z           2604    18599 !   active_storage_variant_records id    DEFAULT     �   ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);
 P   ALTER TABLE public.active_storage_variant_records ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    209    208            {           2604    18600    announcements announcementID    DEFAULT     �   ALTER TABLE ONLY public.announcements ALTER COLUMN "announcementID" SET DEFAULT nextval('public."announcements_announcementID_seq"'::regclass);
 M   ALTER TABLE public.announcements ALTER COLUMN "announcementID" DROP DEFAULT;
       public          test_app    false    211    210            |           2604    18601    attendances id    DEFAULT     p   ALTER TABLE ONLY public.attendances ALTER COLUMN id SET DEFAULT nextval('public.attendances_id_seq'::regclass);
 =   ALTER TABLE public.attendances ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    214    213            }           2604    18602 	   events id    DEFAULT     f   ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);
 8   ALTER TABLE public.events ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    216    215            ~           2604    18603 	   points id    DEFAULT     f   ALTER TABLE ONLY public.points ALTER COLUMN id SET DEFAULT nextval('public.points_id_seq'::regclass);
 8   ALTER TABLE public.points ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    218    217                       2604    18604    rsvps id    DEFAULT     d   ALTER TABLE ONLY public.rsvps ALTER COLUMN id SET DEFAULT nextval('public.rsvps_id_seq'::regclass);
 7   ALTER TABLE public.rsvps ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    220    219            �           2604    18605    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          test_app    false    223    222            1          0    18503    action_text_rich_texts 
   TABLE DATA           p   COPY public.action_text_rich_texts (id, name, body, record_type, record_id, created_at, updated_at) FROM stdin;
    public          test_app    false    202   ��       3          0    18511    active_storage_attachments 
   TABLE DATA           k   COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
    public          test_app    false    204   ��       5          0    18519    active_storage_blobs 
   TABLE DATA           �   COPY public.active_storage_blobs (id, key, filename, content_type, metadata, service_name, byte_size, checksum, created_at) FROM stdin;
    public          test_app    false    206   ڬ       7          0    18527    active_storage_variant_records 
   TABLE DATA           W   COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
    public          test_app    false    208   ��       9          0    18535    announcements 
   TABLE DATA           �   COPY public.announcements ("googleUserID", subject, "dateOfAnnouncement", body, created_at, updated_at, "announcementID") FROM stdin;
    public          test_app    false    210   �       ;          0    18543    ar_internal_metadata 
   TABLE DATA           R   COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
    public          test_app    false    212   1�       <          0    18549    attendances 
   TABLE DATA           ~   COPY public.attendances (id, "eventID", "googleUserID", "timeOfCheckIn", "pointsAwarded", created_at, updated_at) FROM stdin;
    public          test_app    false    213   ��       >          0    18557    events 
   TABLE DATA           �   COPY public.events (id, "eventLocation", "eventInfo", "eventName", "eventTime", created_at, updated_at, "eventPoints", sponsor_title, sponsor_description, password) FROM stdin;
    public          test_app    false    215   ��       @          0    18565    points 
   TABLE DATA           �   COPY public.points (id, "numPointsAwarded", "awardedBy", "awardedTo", "dateOfAward", "awardDescription", created_at, updated_at, "PointID") FROM stdin;
    public          test_app    false    217   ˭       B          0    18573    rsvps 
   TABLE DATA           O   COPY public.rsvps (id, user_uid, event_id, created_at, updated_at) FROM stdin;
    public          test_app    false    219   �       D          0    18581    schema_migrations 
   TABLE DATA           4   COPY public.schema_migrations (version) FROM stdin;
    public          test_app    false    221   �       E          0    18587    users 
   TABLE DATA             COPY public.users (id, uid, email, is_admin, full_name, middle_initial, gender, is_hispanic_or_latino, race, is_us_citizen, is_first_generation_college_student, date_of_birth, phone_number, avatar_url, bio, classification, total_points, created_at, updated_at, role) FROM stdin;
    public          test_app    false    222   ��       W           0    0    action_text_rich_texts_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.action_text_rich_texts_id_seq', 13, true);
          public          test_app    false    203            X           0    0 !   active_storage_attachments_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 1, false);
          public          test_app    false    205            Y           0    0    active_storage_blobs_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 1, false);
          public          test_app    false    207            Z           0    0 %   active_storage_variant_records_id_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 1, false);
          public          test_app    false    209            [           0    0     announcements_announcementID_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."announcements_announcementID_seq"', 13, true);
          public          test_app    false    211            \           0    0    attendances_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.attendances_id_seq', 15, true);
          public          test_app    false    214            ]           0    0    events_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.events_id_seq', 51, true);
          public          test_app    false    216            ^           0    0    points_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.points_id_seq', 13, true);
          public          test_app    false    218            _           0    0    rsvps_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.rsvps_id_seq', 1, true);
          public          test_app    false    220            `           0    0    users_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.users_id_seq', 271, true);
          public          test_app    false    223            �           2606    18607 2   action_text_rich_texts action_text_rich_texts_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.action_text_rich_texts
    ADD CONSTRAINT action_text_rich_texts_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.action_text_rich_texts DROP CONSTRAINT action_text_rich_texts_pkey;
       public            test_app    false    202            �           2606    18609 :   active_storage_attachments active_storage_attachments_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.active_storage_attachments DROP CONSTRAINT active_storage_attachments_pkey;
       public            test_app    false    204            �           2606    18611 .   active_storage_blobs active_storage_blobs_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.active_storage_blobs DROP CONSTRAINT active_storage_blobs_pkey;
       public            test_app    false    206            �           2606    18613 B   active_storage_variant_records active_storage_variant_records_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);
 l   ALTER TABLE ONLY public.active_storage_variant_records DROP CONSTRAINT active_storage_variant_records_pkey;
       public            test_app    false    208            �           2606    18615     announcements announcements_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY ("announcementID");
 J   ALTER TABLE ONLY public.announcements DROP CONSTRAINT announcements_pkey;
       public            test_app    false    210            �           2606    18617 .   ar_internal_metadata ar_internal_metadata_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);
 X   ALTER TABLE ONLY public.ar_internal_metadata DROP CONSTRAINT ar_internal_metadata_pkey;
       public            test_app    false    212            �           2606    18619    attendances attendances_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.attendances DROP CONSTRAINT attendances_pkey;
       public            test_app    false    213            �           2606    18621    events events_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.events DROP CONSTRAINT events_pkey;
       public            test_app    false    215            �           2606    18623    points points_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.points
    ADD CONSTRAINT points_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.points DROP CONSTRAINT points_pkey;
       public            test_app    false    217            �           2606    18625    rsvps rsvps_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.rsvps
    ADD CONSTRAINT rsvps_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.rsvps DROP CONSTRAINT rsvps_pkey;
       public            test_app    false    219            �           2606    18627 (   schema_migrations schema_migrations_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
 R   ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
       public            test_app    false    221            �           2606    18629    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            test_app    false    222            �           1259    18630 '   index_action_text_rich_texts_uniqueness    INDEX     �   CREATE UNIQUE INDEX index_action_text_rich_texts_uniqueness ON public.action_text_rich_texts USING btree (record_type, record_id, name);
 ;   DROP INDEX public.index_action_text_rich_texts_uniqueness;
       public            test_app    false    202    202    202            �           1259    18631 +   index_active_storage_attachments_on_blob_id    INDEX     u   CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);
 ?   DROP INDEX public.index_active_storage_attachments_on_blob_id;
       public            test_app    false    204            �           1259    18632 +   index_active_storage_attachments_uniqueness    INDEX     �   CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);
 ?   DROP INDEX public.index_active_storage_attachments_uniqueness;
       public            test_app    false    204    204    204    204            �           1259    18633 !   index_active_storage_blobs_on_key    INDEX     h   CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);
 5   DROP INDEX public.index_active_storage_blobs_on_key;
       public            test_app    false    206            �           1259    18634 /   index_active_storage_variant_records_uniqueness    INDEX     �   CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);
 C   DROP INDEX public.index_active_storage_variant_records_uniqueness;
       public            test_app    false    208    208            �           1259    18635    index_rsvps_on_event_id    INDEX     M   CREATE INDEX index_rsvps_on_event_id ON public.rsvps USING btree (event_id);
 +   DROP INDEX public.index_rsvps_on_event_id;
       public            test_app    false    219            �           1259    18636    index_users_on_email    INDEX     N   CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);
 (   DROP INDEX public.index_users_on_email;
       public            test_app    false    222            �           1259    18637    index_users_on_uid    INDEX     J   CREATE UNIQUE INDEX index_users_on_uid ON public.users USING btree (uid);
 &   DROP INDEX public.index_users_on_uid;
       public            test_app    false    222            �           2620    18638 2   events update_attendance_points_after_event_update    TRIGGER     �   CREATE TRIGGER update_attendance_points_after_event_update AFTER UPDATE OF "eventPoints" ON public.events FOR EACH ROW EXECUTE FUNCTION public.update_attendance_points();
 K   DROP TRIGGER update_attendance_points_after_event_update ON public.events;
       public          test_app    false    215    239    215            �           2620    18639 *   attendances update_points_after_attendance    TRIGGER     �   CREATE TRIGGER update_points_after_attendance AFTER INSERT ON public.attendances FOR EACH ROW EXECUTE FUNCTION public.update_user_total_points_from_attendance();
 C   DROP TRIGGER update_points_after_attendance ON public.attendances;
       public          test_app    false    213    242            �           2620    18640 !   points update_points_after_delete    TRIGGER     �   CREATE TRIGGER update_points_after_delete AFTER DELETE ON public.points FOR EACH ROW EXECUTE FUNCTION public.update_user_total_points();
 :   DROP TRIGGER update_points_after_delete ON public.points;
       public          test_app    false    217    241            �           2620    18641 '   events update_points_after_event_update    TRIGGER     �   CREATE TRIGGER update_points_after_event_update AFTER UPDATE ON public.events FOR EACH ROW WHEN ((old."eventPoints" IS DISTINCT FROM new."eventPoints")) EXECUTE FUNCTION public.update_user_points_from_event_change();
 @   DROP TRIGGER update_points_after_event_update ON public.events;
       public          test_app    false    215    215    240            �           2620    18642 +   points update_points_after_insert_or_update    TRIGGER     �   CREATE TRIGGER update_points_after_insert_or_update AFTER INSERT OR UPDATE ON public.points FOR EACH ROW EXECUTE FUNCTION public.update_user_total_points();
 D   DROP TRIGGER update_points_after_insert_or_update ON public.points;
       public          test_app    false    217    241            �           2606    18643    rsvps fk_rails_115d52081c    FK CONSTRAINT     z   ALTER TABLE ONLY public.rsvps
    ADD CONSTRAINT fk_rails_115d52081c FOREIGN KEY (event_id) REFERENCES public.events(id);
 C   ALTER TABLE ONLY public.rsvps DROP CONSTRAINT fk_rails_115d52081c;
       public          test_app    false    219    215    2966            �           2606    18648    attendances fk_rails_67d4100843    FK CONSTRAINT     �   ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT fk_rails_67d4100843 FOREIGN KEY ("eventID") REFERENCES public.events(id);
 I   ALTER TABLE ONLY public.attendances DROP CONSTRAINT fk_rails_67d4100843;
       public          test_app    false    213    215    2966            �           2606    18653 !   announcements fk_rails_94e3afa72b    FK CONSTRAINT     �   ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT fk_rails_94e3afa72b FOREIGN KEY ("googleUserID") REFERENCES public.users(uid) ON DELETE SET NULL;
 K   ALTER TABLE ONLY public.announcements DROP CONSTRAINT fk_rails_94e3afa72b;
       public          test_app    false    222    210    2975            �           2606    18658 2   active_storage_variant_records fk_rails_993965df05    FK CONSTRAINT     �   ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);
 \   ALTER TABLE ONLY public.active_storage_variant_records DROP CONSTRAINT fk_rails_993965df05;
       public          test_app    false    208    206    2954            �           2606    18663    points fk_rails_9cc02d9953    FK CONSTRAINT     �   ALTER TABLE ONLY public.points
    ADD CONSTRAINT fk_rails_9cc02d9953 FOREIGN KEY ("awardedTo") REFERENCES public.users(uid) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.points DROP CONSTRAINT fk_rails_9cc02d9953;
       public          test_app    false    217    222    2975            �           2606    18668 .   active_storage_attachments fk_rails_c3b3935057    FK CONSTRAINT     �   ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);
 X   ALTER TABLE ONLY public.active_storage_attachments DROP CONSTRAINT fk_rails_c3b3935057;
       public          test_app    false    204    206    2954            �           2606    18673    attendances fk_rails_c47ec2e1a2    FK CONSTRAINT     �   ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT fk_rails_c47ec2e1a2 FOREIGN KEY ("googleUserID") REFERENCES public.users(uid) ON DELETE SET NULL;
 I   ALTER TABLE ONLY public.attendances DROP CONSTRAINT fk_rails_c47ec2e1a2;
       public          test_app    false    213    2975    222            �           2606    18678    rsvps fk_rails_fbc918ec10    FK CONSTRAINT     �   ALTER TABLE ONLY public.rsvps
    ADD CONSTRAINT fk_rails_fbc918ec10 FOREIGN KEY (user_uid) REFERENCES public.users(uid) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.rsvps DROP CONSTRAINT fk_rails_fbc918ec10;
       public          test_app    false    2975    219    222            1      x������ � �      3      x������ � �      5      x������ � �      7      x������ � �      9      x������ � �      ;   P   x�-�1�  ����@J-��-n��`1}��w��ڛ]ņ�{;�c�f���#�H��(S�y�?��9YSR� 7� |�9�      <      x������ � �      >      x������ � �      @      x������ � �      B      x������ � �      D   �   x�U��� �;�d$����_�z2@���B|9� b4ݤ���ELɨ���kŉ�)N�Ú�X���=2�Ԫg8������<"i{�a�YO����d׀?�ݦ��#b�j�L�E�C�a'�>�/����<�Г���ֳ�����WF�      E      x������ � �     