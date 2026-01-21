import { Request, Response } from "express";
import { RegisterSchema, LoginSchema } from "../types/user.type";
import { registerUser, loginUser } from "../services/user.service";

export const register = async (req: Request, res: Response) => {
    const result = RegisterSchema.safeParse(req.body);

    if (!result.success) {
        return res.status(400).json({
            success: false,
            message: "Validation failed",
            errors: result.error.format(),  // This is better and clean
        });
    }

    try {
        const data = await registerUser(result.data);
        res.status(201).json({ success: true, ...data });
    } catch (error: any) {
        res.status(error.statusCode || 500).json({
            success: false,
            message: error.message || "Server error",
        });
    }
};

export const login = async (req: Request, res: Response) => {
    const result = LoginSchema.safeParse(req.body);

    if (!result.success) {
        return res.status(400).json({
            success: false,
            message: "Validation failed",
            errors: result.error.format(),  // Clean formatted errors
        });
    }

    try {
        const data = await loginUser(result.data);
        res.json({ success: true, ...data });
    } catch (error: any) {
        res.status(error.statusCode || 500).json({
            success: false,
            message: error.message || "Server error",
        });
    }
};