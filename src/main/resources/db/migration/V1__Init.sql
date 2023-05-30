alter table if exists environment_variable_aud drop foreign key if exists FK95388aqphlq2m3i8ugqigpg78;

drop table if exists environment_variable_aud;
drop table if exists environment_variable;
drop table if exists revinfo;

create table environment_variable_aud (
    id bigint not null,
    name varchar(255),
    data varchar(255),
    description varchar(255),
    is_deleted bit,
    rev integer not null,
    revtype tinyint,
    created_at datetime(6),
    updated_at datetime(6),
    primary key (rev, id)
) engine=InnoDB;

create table environment_variable (
    id bigint not null auto_increment,
    data varchar(255),
    name varchar(255),
    description varchar(255),
    is_deleted bit not null,
    created_at datetime(6),
    updated_at datetime(6),
    primary key (id)
) engine=InnoDB;

create table revinfo (
    rev integer not null auto_increment,
    revtstmp bigint, primary key (rev)
) engine=InnoDB;

alter table if exists environment_variable_aud add constraint FK95388aqphlq2m3i8ugqigpg78 foreign key (rev) references revinfo (rev);