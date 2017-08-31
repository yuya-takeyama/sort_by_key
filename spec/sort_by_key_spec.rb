require 'sort_by_key'

describe SortByKey do
  describe '.sort_by_key' do
    subject { SortByKey.sort_by_key(input) }

    let(:input) { { foo: 1, bar: 2, baz: 3 } }

    it 'sort keys of Hash' do
      expect(subject).to eq(input)
      expect(subject.keys).to eq [:bar, :baz, :foo]
    end

    context 'with nested Hash' do
      let(:input) do
        {
          foo: 1,
          bar: 2,
          baz: {
            hoge: 3,
            fuga: 4,
            piyo: {
              spam: 5,
              ham: 6,
              egg: 7,
            },
          },
        }
      end

      context 'without `recursive: true` option' do
        it 'does not sort keys of inner Hash' do
          expect(subject).to eq input
          expect(subject.keys).to eq [:bar, :baz, :foo]
          expect(subject[:baz].keys).to eq [:hoge, :fuga, :piyo]
          expect(subject[:baz][:piyo].keys).to eq [:spam, :ham, :egg]
        end
      end

      context 'with `recursive: true` option' do
        subject { SortByKey.sort_by_key(input, recursive: true) }

        it 'sorts keys of inner Hash as well' do
          expect(subject).to eq input
          expect(subject.keys).to eq [:bar, :baz, :foo]
          expect(subject[:baz].keys).to eq [:fuga, :hoge, :piyo]
          expect(subject[:baz][:piyo].keys).to eq [:egg, :ham, :spam]
        end
      end
    end

    context 'with nested Hash which contains Array' do
      let(:input) do
        {
          foo: 1,
          bar: 2,
          baz: [
            {
              hoge: 3,
              fuga: 4,
              piyo: 5,
            },
            {
              spam: 6,
              ham: 7,
              egg: 8,
            },
          ],
        }
      end

      context 'without `recursive: true` option' do
        it 'does not sort keys of inner Hash' do
          expect(subject).to eq input
          expect(subject.keys).to eq [:bar, :baz, :foo]
          expect(subject[:baz][0].keys).to eq [:hoge, :fuga, :piyo]
          expect(subject[:baz][1].keys).to eq [:spam, :ham, :egg]
        end
      end

      context 'with `recursive: true` option' do
        subject { SortByKey.sort_by_key(input, recursive: true) }

        it 'sorts keys of inner Hash as well' do
          expect(subject).to eq input
          expect(subject.keys).to eq [:bar, :baz, :foo]
          expect(subject[:baz][0].keys).to eq [:fuga, :hoge, :piyo]
          expect(subject[:baz][1].keys).to eq [:egg, :ham, :spam]
        end
      end
    end
  end
end
