/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package db

import (
	"go.mongodb.org/mongo-driver/bson/primitive"
	"time"
)

type EventNew struct {
	ID        primitive.ObjectID `json:"id" bson:"_id"`
	Name      string             `json:"name" bson:"name"`
	Body      string             `json:"body" bson:"body"`
	Picture   string             `json:"picture" bson:"picture"`
	CreatedAt time.Time          `json:"created_at" bson:"created_at" form:"created_at"`
	UpdatedAt time.Time          `json:"updated_at" bson:"updated_at" form:"updated_at"`
}
