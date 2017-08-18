#include <iostream>
#include <vector>
#include <ctime>
#include <cmath>

using namespace std;

auto sigma = [](double x) { return 1.0 / (1.0 + exp(-(x))); };

double alpha = 0.6;
double weight_init_min = -0.3;
double weight_init_max = 0.3;

struct neuron {
    vector<double> weights;
    vector<double> inputs;
    double output;
    
    neuron(int n_inputs) {
        inputs.resize(n_inputs);
        weights.resize(n_inputs);
        for(auto& x: inputs)
            x = 0.0;
        for(auto& x: weights) {
            double base = static_cast<double>(rand() % 1000);
            x = weight_init_min + (weight_init_max - weight_init_min) * base / 1000.0;
        }
    };
    
    void activation() {
        output = 0;
        for(size_t i = 0; i < inputs.size(); i += 1)
            output += sigma(inputs[i]) * weights[i];
    };
};

int main()
{
    srand(time(0));
    vector<vector<neuron>> net(3);
    net[0].emplace_back(2);
    net[0].emplace_back(2);
    
    net[1].emplace_back(2);
    net[1].emplace_back(2);
    net[1].emplace_back(2);
    
    net[2].emplace_back(3);
    
    net[0][0].inputs[0] = 0;
    net[0][0].inputs[1] = 1;

    net[0][1].inputs[0] = 0;
    net[0][1].inputs[1] = 1;
    
    for(size_t layer = 0; layer < net.size(); layer += 1) {
        for(size_t nrn = 0; nrn < net[layer].size(); nrn += 1) {
            net[layer][nrn].activation();
            for(size_t next_layer_neuron = 0; layer + 1 < net.size() && next_layer_neuron < net[layer + 1].size(); next_layer_neuron += 1)
                net[layer + 1][next_layer_neuron].inputs[nrn] = net[layer][nrn].output;
        }
    }
    
    for(const auto& x: net[net.size() - 1])
        cout << x.output << endl;
    
    return 0;
}
