# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

quest = Question.create(title: 'Sample Question')
Choice.create(title: 'Choice 1', question: quest)
Choice.create(title: 'Choice 2', question: quest)
Choice.create(title: 'Choice 3', question: quest)