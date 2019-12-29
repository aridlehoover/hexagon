require_relative '../../../lib/data_stores/in_memory_store'
require_relative '../../../domain/entities/user'

describe DataStores::InMemoryStore do
  subject(:store) { described_class.new(klass) }

  let(:klass) { User }
  let(:mickey) { { name: 'Mickey Mouse' } }
  let(:donald) { { name: 'Donald Duck' } }
  let(:goofy)  { { name: 'Goofy' } }

  before { store.clear }

  context 'when there is a single store' do
    describe '#find_all' do
      subject(:find_all) { store.find_all }

      context 'when the store is empty' do
        it 'returns an empty array' do
          expect(find_all.count).to eq(0)
        end
      end

      context 'when the store contains entities' do
        before do
          store.create(mickey)
          store.create(donald)
          store.create(goofy)
        end

        it 'returns all of the entities' do
          expect(find_all.count).to eq(3)
        end
      end
    end

    describe '#find' do
      subject(:find) { store.find(id) }

      context 'when the id is not an integer' do
        let(:id) { 'not an integer' }

        it 'throws an ArgumentError' do
          expect { find }.to raise_error(ArgumentError)
        end
      end

      context 'when the id is an integer' do
        context 'and the id is less than one' do
          let(:id) { 0 }

          it 'throws an ArgumentError' do
            expect { find }.to raise_error(ArgumentError)
          end
        end

        context 'and the id is greater than one' do
          context 'and the store is empty' do
            let(:id) { 1 }

            it 'returns nil' do
              expect(find).to be_nil
            end
          end

          context 'and the store contains entities' do
            before do
              store.create(mickey)
              store.create(donald)
              store.create(goofy)
            end

            context 'and the id is not in the store' do
              let(:id) { 99 }

              it 'returns nil' do
                expect(find).to be_nil
              end
            end

            context 'and the id is in the store' do
              let(:id) { store.find_all.first.id   }

              it 'returns the requested entity' do
                expect(find.id).to eq(id)
              end
            end
          end
        end
      end
    end

    describe '#create' do
      subject(:create) { store.create(attributes) }

      context 'when the attributes are not a hash' do
        let(:attributes) { 'not a hash' }

        it 'throws an argument error' do
          expect { store.create(attributes) }.to raise_error(ArgumentError)
        end
      end

      context 'when the attributes is a hash' do
        context 'and the id is set' do
          let(:attributes) { mickey.merge(id: 1) }

          it 'throws an argument error' do
            expect { store.create(attributes) }.to raise_error(ArgumentError)
          end
        end

        context 'and the id is not set' do
          let(:attributes) { mickey }

          it 'adds the entity to the store' do
            expect { create }.to change { store.find_all.count }.from(0).to(1)
          end

          it 'returns the newly created entity' do
            expect(create).to be_a(klass)
          end

          it 'sets the id on the newly created entity' do
            expect(create.id).to be_a(Integer)
          end

          it 'adds a created_at and updated_at dates to the entity' do
            expect(create.created_at).to_not be_nil
          end

          it 'adds a updated_at date to the entity' do
            expect(create.updated_at).to_not be_nil
          end

          it 'created_at and upated_at are the same' do
            entity = create
            expect(entity.created_at).to eq(entity.updated_at)
          end

          context 'when there are existing entities' do
            let(:attributes) { goofy }

            before do
              store.create(mickey)
              store.create(donald)
            end

            it 'assigns the next sequential id to the new entity' do
              previous_high_id = store.find_all.last.id
              expect(create.id).to eq(previous_high_id + 1)
            end
          end
        end
      end
    end

    describe '#clear' do
      context 'when the store is initialized' do
        before { store.clear }

        it 'empties store contents' do
          expect(store.find_all).to eq([])
        end
      end

      context 'when there are entities in the store' do
        before do
          store.create(mickey)
          store.create(donald)
          store.create(goofy)

          store.clear
        end

        it 'empties store contents' do
          expect(store.find_all).to eq([])
        end

        it 'resets the id space' do
          expect(store.create(mickey).id).to eq(1)
        end
      end
    end

    describe '#delete' do
      subject(:delete) { store.delete(id) }

      before do
        store.create(mickey)
        store.create(donald)
        store.create(goofy)
      end

      context 'and the id passed is nil' do
        let(:id) { nil }

        it 'throws an ArgumentError' do
          expect { delete }.to raise_error(ArgumentError)
        end
      end

      context 'and id passed is an integer less than one' do
        let(:id) { 0 }

        it 'throws an ArgumentError' do
          expect { delete }.to raise_error(ArgumentError)
        end
      end

      context 'and id passed is an entity in the store' do
        let(:id) { store.find_all[1] }

        it 'removes the entity from the store' do
          expect { delete }.to change{ store.find_all.count }.from(3).to(2)
        end
      end

      context 'and id passed is an integer' do
        context 'and the id is not in the store' do
          let(:id) { store.find_all.count + 1 }

          it 'removes the entity from the store' do
            expect { delete }.to change{ store.find_all.count }.from(3).to(2)
          end
        end

        context 'and the id is in the store' do
          let(:id) { 1 }

          it 'removes the entity from the store' do
            expect { delete }.to change{ store.find_all.count }.from(3).to(2)
          end

          it 'returns the deleted entity' do
            expect(delete.id).to eq(1)
          end
        end
      end
    end
  end

  context 'when there two instances of stores for same entity' do
    context 'and there are entities in one' do
      let(:store2) { described_class.new(klass) }

      before do
        store.create(mickey)
        store.create(donald)
        store.create(goofy)
      end

      it 'find_all returns the same entities from both instances' do
        expect(store.find_all).to eq(store2.find_all)
      end
    end
  end

  context 'when there two stores for different entities' do
    context 'and there are entities in one' do
      let(:store2) { described_class.new(klass2) }
      let(:klass2) { Network }

      before do
        store.create(mickey)
        store.create(donald)
        store.create(goofy)
      end

      it 'the first store contains the entities' do
        expect(store.find_all.count).to eq(3)
      end

      it 'the second store remains empty' do
        expect(store2.find_all).to eq([])
      end
    end
  end
end
