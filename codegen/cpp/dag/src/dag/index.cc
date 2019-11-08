// Copyright 2018-2019 Delft University of Technology
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "dag/index.h"

#include <string>

#include "dag/dag.h"

namespace dag {

Graph IndexIfTrue(const PrimRef &index_type) {
  Graph result;
  result.name = "IndexIfTrue";
  result += In("in", list(bool_()));
  result += Out("out", list(index_type));
  return result;
}

Graph SelectByIndex(const TypeRef &t, const PrimRef &index_type) {
  Graph result;
  result.name = "FilterByIndex";
  result += In("in", list(t));
  result += In("index", list(index_type));
  result += Out("out", list(t));
  return result;
}

}  // namespace dag