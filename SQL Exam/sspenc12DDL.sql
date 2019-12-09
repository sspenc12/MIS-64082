/* Create table named customers */

CREATE TABLE customers (
    customer_id       Number(*,0)            NOT NULL,
    email_address     Varchar2(255 CHAR)     NOT NULL,
    full_name         Varchar2(255 CHAR)     NOT NULL,
    CONSTRAINT        customers_pk           PRIMARY KEY (customer_id),
    CONSTRAINT        customers_email_u      UNIQUE (email_address),
    CONSTRAINT        full_name_chk1         CHECK (LEN(full_name) >= 2),
    CONSTRAINT        email_address_chk1     CHECK (email_address LIKE '%_@_%')
    );

COMMIT

/* Create table named orders */

CREATE TABLE orders (
    order_id         NUMBER(*,0)              NOT NULL,
    order_datetime   TIMESTAMP                NOT NULL,
    customer_id      NUMBER(*,0)              NOT NULL,
    order_status     VARCHAR2(10 CHAR)        DEFAULT 'PROCESSING'   NOT NULL,
    store_id         NUMBER(*,0)              NOT NULL,
    CONSTRAINT       orders_pk                PRIMARY KEY (order_id),
    CONSTRAINT       orders_customer_id_fk    FOREIGN KEY (customer_id)
    REFERENCES       customers(customer_id)
);

COMMIT

/* Create table named products */

CREATE TABLE products (
    product_id          NUMBER(*,0)         NOT NULL,
    product_name        VARCHAR2(255 CHAR)  NOT NULL,
    unit_price          NUMBER(10,2)        NULL,
    product_details     BLOB                NULL,
    product_image       BLOB                NULL,
    image_mime_type     VARCHAR2(512 CHAR)  NULL,
    image_filename      VARCHAR2(512 CHAR)  NULL,
    image_charset       VARCHAR2(512 CHAR)  NULL,
    image_last_updated  DATE                NULL,
    CONSTRAINT          products_pk         PRIMARY KEY (product_id),
    CONSTRAINT          unit_price_chk1     CHECK ((unit_price >= 0.01) AND (unit_price <= 10000))
);

COMMIT

/* Create table named order_items */

CREATE TABLE order_items (
    order_id        NUMBER(*,0)               NOT NULL,
    line_item_id    NUMBER(*,0)               NOT NULL,
    product_id      NUMBER(*,0)               NOT NULL,
    unit_price      NUMBER(10,2)              NOT NULL,
    quantity        NUMBER(*,0)               DEFAULT 1           NOT NULL,
    line_id         NUMBER                    NOT NULL,
    CONSTRAINT      order_items_pk            PRIMARY KEY (line_id),
    CONSTRAINT      order_items_order_id_fk   FOREIGN KEY (order_id)
    REFERENCES      orders(order_id),
    CONSTRAINT      order_items_product_id_fk FOREIGN KEY (product_id)
    REFERENCES      products(product_id),
    CONSTRAINT      order_items_uk1           UNIQUE (order_id, line_item_id),
    CONSTRAINT      order_items_product_u     UNIQUE (product_id, order_id)
);

COMMIT

/* Create table named suppliers */

CREATE TABLE suppliers (
    supplier_id     NUMBER(38)                NOT NULL,
    supplier_name   VARCHAR2(255 BYTE)        NOT NULL,
    main_contact    VARCHAR2(255 BYTE)        NULL,
    main_phone      VARCHAR2(50 BYTE)         NULL,
    main_email      VARCHAR2(255 BYTE)        NULL,
    CONSTRAINT      suppliers_pk              PRIMARY KEY (supplier_id),
    CONSTRAINT      suppliers_uk1             UNIQUE (supplier_name)
);

COMMIT

/* Create table named supplier_manu */

CREATE TABLE supplier_manu  (
    supplier_manu_id    NUMBER(38)                NOT NULL,
    is_iso9000cert      CHAR(1 BYTE)              DEFAULT 'N'               NOT NULL,
    is_sme_lean_cert    CHAR(1 BYTE)              NOT NULL,
    CONSTRAINT          supplier_manu_pk          PRIMARY KEY (supplier_manu_id),
    CONSTRAINT          supplier_manu_fk1         FOREIGN KEY (supplier_manu_id)
    REFERENCES          suppliers(supplier_id),
    CONSTRAINT          is_iso9000cert_chk1       CHECK (is_iso9000cert IN ('Y', 'N'))
);

COMMIT

/* Create table named supplier_ws */

CREATE TABLE supplier_ws  (
    supplier_ws_id      NUMBER(38)                NOT NULL,
    wholesale_license   VARCHAR2(20 BYTE)         NULL,
    ein                 VARCHAR2(20 BYTE)         NULL,
    CONSTRAINT          supplier_ws_pk            PRIMARY KEY (supplier_ws_id),
    CONSTRAINT          supplier_ws_fk1           FOREIGN KEY (supplier_ws_id)
    REFERENCES          suppliers(supplier_id)
);

COMMIT

/* Create table named shipments */

CREATE TABLE shipments (
    line_id             NUMBER                    NOT NULL,
    supplier_id         NUMBER(38)                NOT NULL,
    quantity_shipped    NUMBER(38,4)              NOT NULL,
    shipper             VARCHAR2(127 BYTE)        NULL,
    tracking_num        VARCHAR2(127 BYTE)        NULL,
    shipdate            DATE                      NULL,
    CONSTRAINT          shipments_pk              PRIMARY KEY (line_id, supplier_id),
    CONSTRAINT          shipments_fk1             FOREIGN KEY (supplier_id)
    REFERENCES          suppliers(supplier_id),
    CONSTRAINT          shipments_fk2             FOREIGN KEY (line_id)
    REFERENCES          order_items(line_id)
);

COMMIT
