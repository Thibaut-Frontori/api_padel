import { pool } from "../db.js";

export default class BaseMapper <T> {
    protected tableName: string;

    constructor(tableName: string) {
        this.tableName = tableName;
    }

    async findAll(): Promise<T[]> {
        const { rows } = await pool.query(`SELECT * FROM "${this.tableName}"`);
        return rows;
    }

    async findById(id: number): Promise<T> {
        const { rows } = await pool.query(`SELECT * FROM "${this.tableName}" WHERE id = $1`, [id]);
        return rows[0];
    }

    async create(data: Record<string, any>): Promise<T> {
        const columns = Object.keys(data).join(', ');
        const values = Object.values(data);
        const params = Object.keys(data).map((_, i) => `$${i + 1}`).join(', ');

        const { rows } = await pool.query(`INSERT INTO "${this.tableName}" (${columns}) VALUES (${params}) RETURNING *`, values);
        return rows[0];
    }

    async delete (id: number): Promise<T> {
        const { rows } = await pool.query(`DELETE FROM "${this.tableName}" WHERE id = $1 RETURNING *`, [id]);
        return rows[0];
    }

    async update (id: number, data: Record<string, any>): Promise<T> {
        const columns = Object.keys(data).map((key, i) => `${key} = $${i + 1}`).join(', ');
        const values = Object.values(data);
        const { rows } = await pool.query(`UPDATE "${this.tableName}" SET ${columns} WHERE id = $${values.length + 1} RETURNING *`, [...values, id]);
        return rows[0];
    }

}