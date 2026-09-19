#!/usr/bin/env node
// Front-matter identity between English blog posts and their Turkish twins.
//
// WHY: Docusaurus builds a Turkish post with whatever front matter it carries.
// A tag present on one side only produces a tag page the other locale links
// to but never builds (Rentiva v4.36.0: CI broke on it); a different date
// reorders the two archives; a different slug splits one post into two URLs.
// check-links.sh catches the tag case only indirectly, after a build. This
// compares the source, per pair, and names the key.
//
// Rules, per EN/TR pair (same relative path under the two dirs):
//   - slug, date, authors, tags must exist and be non-empty on BOTH sides
//     (equality alone would pass empty==empty — a gate green because it never
//     matched);
//   - they must be equal after normalisation: tags/authors compared as sorted
//     sets (flow `[a, b]` and block `- a` lists parse to the same set), Date
//     objects compared as ISO strings, everything else as strings.
// A missing twin is check-locale-parity.sh's finding, not this script's.
//
// Output: "PAIRS <n>" then zero or more "PROBLEM <text>" lines. Exit 0 when it
// could measure (problems are reported, not signalled by exit code); exit 2
// when it could not (js-yaml missing, unreadable dir).
'use strict';
const fs = require('fs');
const path = require('path');

let yaml;
try {
  yaml = require('js-yaml');
} catch (e) {
  console.log('ERROR js-yaml is not installed — run npm ci first.');
  process.exit(2);
}

const [enDir, trDir] = process.argv.slice(2);
if (!enDir || !trDir) {
  console.log('ERROR usage: blog-frontmatter-parity.js <en-dir> <tr-dir>');
  process.exit(2);
}
const KEYS = ['slug', 'date', 'authors', 'tags'];

function walk(dir) {
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap((e) => {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) return walk(p);
    return /\.mdx?$/.test(e.name) ? [p] : [];
  });
}

// Returns the parsed front matter, null when there is none, or
// { __yamlError: reason } when it is not valid YAML — a broken post is a
// finding to name, not a crash that hides which file it was.
function frontMatter(file) {
  const text = fs.readFileSync(file, 'utf8').replace(/^﻿/, '');
  const m = text.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n/);
  if (!m) return null;
  try {
    const data = yaml.load(m[1]);
    return data && typeof data === 'object' ? data : {};
  } catch (e) {
    return { __yamlError: e.reason || e.message };
  }
}

function norm(key, value) {
  if (value === undefined || value === null || value === '') return null;
  if (value instanceof Date) return value.toISOString();
  if (key === 'tags' || key === 'authors') {
    const list = (Array.isArray(value) ? value : [value]).map((x) =>
      x !== null && typeof x === 'object' ? String(x.label || x.key || JSON.stringify(x)) : String(x)
    );
    if (list.length === 0) return null;
    return JSON.stringify([...new Set(list)].sort());
  }
  return String(value);
}

let posts;
try {
  posts = walk(enDir);
} catch (e) {
  console.log('ERROR cannot read ' + enDir + ': ' + e.message);
  process.exit(2);
}

let pairs = 0;
const problems = [];
for (const en of posts) {
  const rel = path.relative(enDir, en);
  const tr = path.join(trDir, rel);
  if (!fs.existsSync(tr)) continue;
  pairs++;
  const a = frontMatter(en);
  const b = frontMatter(tr);
  if (!a || !b) {
    problems.push(rel + ': no front matter on ' + (!a && !b ? 'EN+TR' : !a ? 'EN' : 'TR'));
    continue;
  }
  if (a.__yamlError || b.__yamlError) {
    if (a.__yamlError) problems.push(rel + ': EN front matter is not valid YAML — ' + a.__yamlError);
    if (b.__yamlError) problems.push(rel + ': TR front matter is not valid YAML — ' + b.__yamlError);
    continue;
  }
  for (const k of KEYS) {
    const x = norm(k, a[k]);
    const y = norm(k, b[k]);
    if (x === null || y === null) {
      const side = x === null && y === null ? 'EN+TR' : x === null ? 'EN' : 'TR';
      problems.push(rel + ': ' + k + ' missing or empty on ' + side);
    } else if (x !== y) {
      problems.push(rel + ': ' + k + ' differs — EN ' + x + ' vs TR ' + y);
    }
  }
}
console.log('PAIRS ' + pairs);
for (const p of problems) console.log('PROBLEM ' + p);
