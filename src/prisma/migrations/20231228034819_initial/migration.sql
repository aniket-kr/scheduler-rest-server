-- CreateEnum
CREATE TYPE "Day" AS ENUM ('MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN');

-- CreateTable
CREATE TABLE "organisations" (
    "id" UUID NOT NULL,
    "email" VARCHAR(254) NOT NULL,
    "password_hash" CHAR(60) NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "bio" TEXT,
    "created_at" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "organisations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "projects" (
    "id" UUID NOT NULL,
    "label" VARCHAR(120) NOT NULL,
    "organisation_id" UUID NOT NULL,

    CONSTRAINT "projects_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "departments" (
    "id" UUID NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "project_id" UUID NOT NULL,

    CONSTRAINT "departments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "time_slots" (
    "id" UUID NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "day" "Day" NOT NULL,
    "start_minutes" SMALLINT NOT NULL,
    "end_minutes" SMALLINT NOT NULL,
    "project_id" UUID NOT NULL,

    CONSTRAINT "time_slots_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "room_types" (
    "id" UUID NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "project_id" UUID NOT NULL,

    CONSTRAINT "room_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rooms" (
    "id" UUID NOT NULL,
    "code" VARCHAR(10) NOT NULL,
    "capacity" INTEGER NOT NULL,
    "room_type_id" UUID NOT NULL,
    "project_id" UUID NOT NULL,
    "department_id" UUID NOT NULL,

    CONSTRAINT "rooms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subjects" (
    "id" UUID NOT NULL,
    "code" VARCHAR(10) NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "room_type_id" UUID NOT NULL,
    "project_id" UUID NOT NULL,

    CONSTRAINT "subjects_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "faculties" (
    "id" UUID NOT NULL,
    "code" VARCHAR(10) NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "project_id" UUID NOT NULL,

    CONSTRAINT "faculties_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "divisions" (
    "id" UUID NOT NULL,
    "code" VARCHAR(10) NOT NULL,
    "strength" INTEGER NOT NULL,
    "project_id" UUID NOT NULL,

    CONSTRAINT "divisions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_FacultyToSubject" (
    "A" UUID NOT NULL,
    "B" UUID NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "organisations_email_key" ON "organisations"("email");

-- CreateIndex
CREATE UNIQUE INDEX "projects_organisation_id_label_key" ON "projects"("organisation_id", "label");

-- CreateIndex
CREATE UNIQUE INDEX "departments_project_id_name_key" ON "departments"("project_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "time_slots_project_id_name_key" ON "time_slots"("project_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "room_types_project_id_name_key" ON "room_types"("project_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "rooms_project_id_code_key" ON "rooms"("project_id", "code");

-- CreateIndex
CREATE UNIQUE INDEX "subjects_project_id_code_key" ON "subjects"("project_id", "code");

-- CreateIndex
CREATE UNIQUE INDEX "faculties_project_id_code_key" ON "faculties"("project_id", "code");

-- CreateIndex
CREATE UNIQUE INDEX "divisions_project_id_code_key" ON "divisions"("project_id", "code");

-- CreateIndex
CREATE UNIQUE INDEX "_FacultyToSubject_AB_unique" ON "_FacultyToSubject"("A", "B");

-- CreateIndex
CREATE INDEX "_FacultyToSubject_B_index" ON "_FacultyToSubject"("B");

-- AddForeignKey
ALTER TABLE "projects" ADD CONSTRAINT "projects_organisation_id_fkey" FOREIGN KEY ("organisation_id") REFERENCES "organisations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "departments" ADD CONSTRAINT "departments_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "time_slots" ADD CONSTRAINT "time_slots_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "room_types" ADD CONSTRAINT "room_types_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rooms" ADD CONSTRAINT "rooms_room_type_id_fkey" FOREIGN KEY ("room_type_id") REFERENCES "room_types"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rooms" ADD CONSTRAINT "rooms_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rooms" ADD CONSTRAINT "rooms_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subjects" ADD CONSTRAINT "subjects_room_type_id_fkey" FOREIGN KEY ("room_type_id") REFERENCES "room_types"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subjects" ADD CONSTRAINT "subjects_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "faculties" ADD CONSTRAINT "faculties_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "divisions" ADD CONSTRAINT "divisions_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_FacultyToSubject" ADD CONSTRAINT "_FacultyToSubject_A_fkey" FOREIGN KEY ("A") REFERENCES "faculties"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_FacultyToSubject" ADD CONSTRAINT "_FacultyToSubject_B_fkey" FOREIGN KEY ("B") REFERENCES "subjects"("id") ON DELETE CASCADE ON UPDATE CASCADE;
