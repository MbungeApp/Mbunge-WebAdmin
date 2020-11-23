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
	"time"
)

// CRUD
type ParticipationDaoInterface interface {
	TotalParticipations() int
	ReadAllParticipation() []db.Participation
	ReadOneParticipation(participationID string) (db.Participation, error)
	CreateParticipation(participation db.Participation) error
	UpdateParticipation(id string, key string, value string) error
	DeleteParticipation(participationID string) error
}

type NewParticipationDaoInterface struct {
	Client *mongo.Client
}

func participationCollection(client *mongo.Client) *mongo.Collection {
	return client.Database("mbunge").Collection("participation")
}
func (p NewParticipationDaoInterface) TotalParticipations() int {
	var participation []db.Participation
	cursor, err := participationCollection(p.Client).Find(context.Background(), bson.M{})
	if err != nil {
		return 0
	}
	err = cursor.All(context.Background(), &participation)
	if err != nil {
		return 0
	}
	return len(participation)
}

func (p NewParticipationDaoInterface) ReadAllParticipation() []db.Participation {
	var participation []db.Participation
	cursor, err := participationCollection(p.Client).Find(context.Background(), bson.M{})
	if err != nil {
		return nil
	}
	err = cursor.All(context.Background(), &participation)
	if err != nil {
		return nil
	}
	return participation
}

func (p NewParticipationDaoInterface) ReadOneParticipation(participationID string) (db.Participation, error) {
	objectID, _ := primitive.ObjectIDFromHex(participationID)
	var participation db.Participation

	err := participationCollection(p.Client).FindOne(context.Background(), bson.D{{"_id", objectID}}).Decode(&participation)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return db.Participation{}, err
		}
		return db.Participation{}, err
	}
	return participation, nil
}
func (p NewParticipationDaoInterface) CreateParticipation(participation db.Participation) error {
	participation.CreatedAt = time.Now()
	participation.UpdatedAt = time.Now()
	participation.ID = primitive.NewObjectID()
	_, err := participationCollection(p.Client).InsertOne(context.Background(), participation)

	if err != nil {
		return err
	}
	return nil
}
func (p NewParticipationDaoInterface) UpdateParticipation(id string, key string, value string) error {
	objID, _ := primitive.ObjectIDFromHex(id)
	filter := bson.D{{"_id", objID}}
	update := bson.D{{Key: "$set", Value: bson.M{key: value, "updated_at": time.Now()}}}

	_, err := participationCollection(p.Client).UpdateOne(
		context.Background(),
		filter,
		update,
	)
	if err != nil {
		return err
	}
	return nil
}
func (p NewParticipationDaoInterface) DeleteParticipation(participationID string) error {
	objectID, _ := primitive.ObjectIDFromHex(participationID)
	_, err := participationCollection(p.Client).DeleteOne(context.Background(), bson.M{
		"_id": objectID,
	})
	if err != nil {
		return err
	}
	return nil
}
