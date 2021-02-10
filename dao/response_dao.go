/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package dao

import (
	"context"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"mbunge-admin/models/db"
)

type ResponseDaoInterface interface {
	TotalResponses() int
	ReadAllResponse(id string) []db.Response
	ReadOneParticipation(responseId string) db.Response
}

type NewResponseDaoInterface struct {
	Client *mongo.Client
}

func responseCollection(client *mongo.Client) *mongo.Collection {
	return client.Database("mbunge").Collection("response")
}
func (r NewResponseDaoInterface) TotalResponses() int {
	var responses []db.Response
	cursor, err := responseCollection(r.Client).Find(context.Background(), bson.M{})
	if err != nil {
		return 0
	}
	err = cursor.All(context.Background(), &responses)
	if err != nil {
		return 0
	}

	return len(responses)
}
func (r NewResponseDaoInterface) ReadAllResponse(id string) []db.Response {
	objectID, _ := primitive.ObjectIDFromHex(id)
	var responses []db.Response
	cursor, err := responseCollection(r.Client).Find(context.Background(), bson.M{
		"_id": objectID,
	})
	if err != nil {
		return nil
	}
	err = cursor.All(context.Background(), &responses)
	if err != nil {
		return nil
	}

	return responses
}
func (r NewResponseDaoInterface) ReadOneParticipation(responseId string) db.Response {
	objectID, _ := primitive.ObjectIDFromHex(responseId)
	var response db.Response

	err := responseCollection(r.Client).FindOne(context.Background(), bson.M{
		"_id": objectID,
	}).Decode(response)
	if err != nil {
		//log.Fatal(err)
		if err == mongo.ErrNoDocuments {
			return db.Response{}
		}
	}
	return response
}
