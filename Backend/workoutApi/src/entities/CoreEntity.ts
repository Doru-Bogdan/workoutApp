import { BaseEntity, PrimaryGeneratedColumn, CreateDateColumn, Column, UpdateDateColumn, ManyToMany, DeleteDateColumn } from "typeorm";

export class CoreEntity extends BaseEntity{
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column()
    @CreateDateColumn()
    createdAt: Date;

    @Column()
    @UpdateDateColumn()
    updatedAt: Date;

    @DeleteDateColumn()
    deletedAt?: Date;

}