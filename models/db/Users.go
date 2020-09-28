/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package db

import (
	"go.mongodb.org/mongo-driver/bson/primitive"
	"time"
)

type User struct {
	ID           primitive.ObjectID `json:"id,omitempty" bson:"_id,omitempty"`
	FirstName    string             `json:"first_name" bson:"first_name" form:"first_name"`
	LastName     string             `json:"last_name" bson:"last_name" form:"last_name"`
	EmailAddress string             `json:"email_address" bson:"email_address" form:"email_address"`
	Password     string             `json:"password" bson:"password" form:"password"`
	PhoneNumber  string             `json:"phone_number" bson:"phone_number" form:"phone_number"`
	DateBirth    time.Time          `json:"date_birth" bson:"date_birth" form:"date_birth"`
	Gender       int                `json:"gender" bson:"gender" form:"gender"`
	Verified     bool               `json:"verified" bson:"verified" form:"verified"`
	County       string             `json:"county" bson:"county" form:"county"`
	CreatedAt    time.Time          `json:"created_at" bson:"created_at" form:"created_at"`
	UpdatedAt    time.Time          `json:"updated_at" bson:"updated_at" form:"updated"`
}
