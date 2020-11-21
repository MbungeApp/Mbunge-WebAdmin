/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package dao

import (
	"context"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"mbunge-admin/models/db"
)

type UserDaoInterface interface {
	GetGenderTotals() (int, int)
	TotalUsers() int
	ReadAllUsers() []db.User
	UsersLocation() []string
}

type NewUserDaoInterface struct {
	Client *mongo.Client
}

func userCollection(client *mongo.Client) *mongo.Collection {
	return client.Database("mbunge").Collection("user")
}
func (s NewUserDaoInterface) GetGenderTotals() (int, int) {
	var users []db.User
	var male = 0
	var female = 0
	cursor, err := userCollection(s.Client).Find(context.Background(), bson.M{})
	if err != nil {
		return 0, 0
	}
	err = cursor.All(context.Background(), &users)
	if err != nil {
		return 0, 0
	}
	for i := 0; i < len(users); i++ {
		if users[i].Gender == 0 {
			male = +1
		} else {
			female = +1
		}
	}
	return male, female
}

func (s NewUserDaoInterface) TotalUsers() int {
	var users []db.User
	cursor, err := userCollection(s.Client).Find(context.Background(), bson.M{})
	if err != nil {
		return 0
	}
	err = cursor.All(context.Background(), &users)
	if err != nil {
		return 0
	}
	return len(users)
}
func (s NewUserDaoInterface) ReadAllUsers() []db.User {
	var users []db.User
	cursor, err := userCollection(s.Client).Find(context.Background(), bson.M{})
	if err != nil {
		return nil
	}
	err = cursor.All(context.Background(), &users)
	if err != nil {
		return nil
	}
	return users
}
func (s NewUserDaoInterface) UsersLocation() []string {
	var locations []string
	var users []db.User
	cursor, err := userCollection(s.Client).Find(context.Background(), bson.M{})
	if err != nil {
		return nil
	}
	err = cursor.All(context.Background(), &users)
	if err != nil {
		return nil
	}
	for _, user := range users {
		locations = append(locations, user.County)
	}
	return locations
}
