/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package db

import (
	"go.mongodb.org/mongo-driver/bson/primitive"
	"time"
)

type Response struct {
	ID              primitive.ObjectID `json:"id" bson:"_id"`
	UserId          string             `json:"user_id" bson:"user_id"`
	ParticipationId string             `json:"participation_id" bson:"participation_id"`
	Body            string             `json:"body" bson:"body"`
	CreatedAt       time.Time          `json:"created_at" bson:"created_at" form:"created_at"`
	UpdatedAt       time.Time          `json:"updated_at" bson:"updated_at" form:"updated_at"`
}
