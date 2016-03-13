describe 'OptClient' do

  context 'v1' do

    context '#init_api' do
      context 'default options' do

        it 'api initialized with default options' do
          instrument = OptClient.init_api
          expect(instrument.version).to eq 'v1'
          expect(instrument.host).to eq 'http://localhost:4567'
          expect(instrument.connected?).to eq false
        end

        it 'api initialized with heroku options' do
          instrument = OptClient.init_api(host: 'https://opttestapi.herokuapp.com/')
          expect(instrument.version).to eq 'v1'
          expect(instrument.host).to eq 'https://opttestapi.herokuapp.com/'
          expect(instrument.connected?).to eq true
        end

      end
    end

    context 'Instrument' do
      let!(:instrument) { OptClient.init_api(host: 'http://localhost:9292') }

      context '.connected?' do
        it 'successfully' do
          expect(instrument.connected?).to eq true
        end
      end

      context '.create' do
        it 'successfully' do
          client = instrument.create(email: 'newemail@gmail.com', mobile: '12334',
                            first_name: 'Stepan', last_name: 'Boichyshyn',
                            permission_type: 'permanent', channel: 'sms',
                            company_name: '3444')
          expect(client.class).to eq(OptClient::Client)
        end

        it 'with error' do
          client = instrument.create(email: 'newemail@gmail.com', mobile: '12334',
                                     first_name: 'Stepan', last_name: 'Boichyshyn',
                                     permission_type: 'permanent', channel: 'sm',
                                     company_name: '3444')
          expect(client.class).to eq(Hash)
          expect(client[:status]).to eq 'error'
        end
      end

      context '.update' do
        let!(:client){
          instrument.create(email: 'update@gmail.com', mobile: '12334',
                            first_name: 'Stepan', last_name: 'Boichyshyn',
                            permission_type: 'permanent', channel: 'sms',
                            company_name: 'update_company1')
        }

        it 'successfully' do
          updated_client = instrument.update(id: client.id, email: 'updated_email@gmail.com')
          expect(updated_client.id).to eq client.id
          expect(updated_client.email).to eq 'updated_email@gmail.com'
        end

        it 'with error' do
          updated_client = instrument.update(email: 'updated_email@gmail.com')
          expect(updated_client[:status]).to eq 'error'
        end
      end

      context 'destroy' do
        let!(:client){
          instrument.create(email: 'update@gmail.com', mobile: '12334',
                            first_name: 'Stepan', last_name: 'Boichyshyn',
                            permission_type: 'permanent', channel: 'sms',
                            company_name: 'destroy_company')
        }
        it 'successfully' do
          expect(instrument.destroy(client.id)).to eq true
        end

        it 'with error' do
          instrument.destroy(client.id)
          expect(instrument.destroy(client.id)[:status]).to eq 'error'
        end

      end
    end

    context 'Client' do
      let!(:instrument) { OptClient.init_api(host: 'http://localhost:9292') }
      context '.attributes' do
        let!(:client){
          OptClient::V1::Client.new(email: 'update@gmail.com', mobile: '12334',
                            first_name: 'Stepan', last_name: 'Boichyshyn',
                            permission_type: 'permanent', channel: 'sms',
                            company_name: 'attributes_company')
        }
        it 'correct' do
          expect(client.attributes).to eq(email: 'update@gmail.com', mobile: '12334',
                                          first_name: 'Stepan', last_name: 'Boichyshyn',
                                          permission_type: 'permanent', channel: 'sms',
                                          company_name: 'attributes_company')
        end

        it 'with error' do
          allow(client).to receive(:attributes).and_raise('error')
          expect{client.attributes}.to raise_error
        end

      end

      context '.create' do
        let!(:client){
          OptClient::V1::Client.new({email: 'create@gmail.com', mobile: '12334',
                                    first_name: 'Stepan', last_name: 'Boichyshyn',
                                    permission_type: 'permanent', channel: 'sms',
                                    company_name: 'client_create_company'}, instrument)
        }

        it 'successfully' do
          returned_client = client.create
          expect(returned_client.class).to eq(OptClient::V1::Client)
          expect(returned_client.id).to_not eq nil
        end

        it 'with error' do
          client.company_name = 'create_with_error_company'
          returned_client = client.create
          client.id = returned_client.id
          expect(client.create[:status]).to eq 'error'
        end
      end

      context '.update' do
        let!(:client){
          instrument.create(email: 'update@gmail.com', mobile: '12334',
                                     first_name: 'Stepan', last_name: 'Boichyshyn',
                                     permission_type: 'permanent', channel: 'sms',
                                     company_name: 'update_company')
        }

        it 'successfully' do
          updated_client = client.update(email: 'newemail@gmail.com')
          expect(updated_client.class).to eq OptClient::V1::Client
          expect(updated_client.email).to eq 'newemail@gmail.com'
        end

        it 'with error' do
          updated_client = client.update(id: nil, email: 'newemail@gmail.com')
          expect(updated_client[:status]).to eq 'error'
        end
      end

      context 'destroy' do
        let!(:client){
          instrument.create(email: 'update@gmail.com', mobile: '12334',
                            first_name: 'Stepan', last_name: 'Boichyshyn',
                            permission_type: 'permanent', channel: 'sms',
                            company_name: 'destroy_company')
        }

        it 'with success' do
          expect(client.destroy).to eq true
        end

        it 'with error' do
          client.id = nil
          expect(client.destroy).to eq false
        end
      end


      context '.save' do
        let(:client){
          instrument.create(email: 'update@gmail.com', mobile: '12334',
                            first_name: 'Stepan', last_name: 'Boichyshyn',
                            permission_type: 'permanent', channel: 'email',
                            company_name: 'save_companyssss')
        }
        let(:client2){
          instrument.create(email: 'update@gmail.com', mobile: '12334',
                            first_name: 'Stepan', last_name: 'Boichyshyn',
                            permission_type: 'permanent', channel: 'email',
                            company_name: 'save_companysssssss')
        }

        it 'create new client' do
          client.id = nil
          client.email = 'createnewclientemail@gmail.com'
          client.company_name = 'new_save_company'

          expect(client.save.class).to eq(OptClient::V1::Client)
          expect(client.company_name).to eq 'new_save_company'
          expect(client.email).to eq 'createnewclientemail@gmail.com'
        end

        it 'update exist client' do
          client2.email = 'updateeixstclient@gmail.com'

          expect(client2.save.class).to eq(OptClient::V1::Client)
          expect(client2.email).to eq 'updateeixstclient@gmail.com'
        end

      end
    end
  end
end


