/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package db

import (
	"go.mongodb.org/mongo-driver/bson/primitive"
	"time"
)

type Participation struct {
	ID        primitive.ObjectID `json:"id" bson:"_id"`
	Name      string             `json:"name" bson:"name"`
	Sector    string             `json:"sector" bson:"sector"`
	Body      string             `json:"body" bson:"body"`
	PostedBy  string             `json:"posted_by" bson:"posted_by"`
	ExpireAt  time.Time          `json:"expire_at" bson:"expire_at"`
	CreatedAt time.Time          `json:"created_at" bson:"created_at" form:"created_at"`
	UpdatedAt time.Time          `json:"updated_at" bson:"updated_at" form:"updated_at"`
}
